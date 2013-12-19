class PrivateMessage < ActiveRecord::Base
  #acts_as_notificable callbacks: ["after_create"], slot: "private_message", from: "sender", tos: ["recipient"]
  acts_as_api
  api_accessible :pm_info do |t|
    t.add :sender
    t.add :recipient
    t.add :id
    t.add :content
    t.add :created_at
  end
  #attr_protected :created_at, :updated_at, :send_deleted_at, :recipient_deleted_at, :account_id, :recipient_id, :read_at, :conversation_id, :private_message_type
  attr_accessible :content

  TYPE_SEND = 0 # first_account -> second_account
  TYPE_RECEIVE = 1 # second_account -> first_account

  # Validations
  validates :content, presence: true, length: { maximum: 140 }
  validates :conversation, presence: true

  # Callbacks
  after_initialize :default_values
  before_create :parse_conversation

  # Associations
  belongs_to :conversation

  # Scopes

  # Methods
  def sender
    return @sender unless self.private_message_type
    return self.conversation.first_account if self.private_message_type == self.class::TYPE_SEND
    return self.conversation.second_account if self.private_message_type == self.class::TYPE_RECEIVE
  end

  def sender=(sender)
    raise "Sender is not an Account." unless sender.is_a?(Account)
    @sender = sender
  end

  def recipient
    return @recipient unless self.private_message_type
    return self.conversation.second_account if self.private_message_type == self.class::TYPE_SEND
    return self.conversation.first_account if self.private_message_type == self.class::TYPE_RECEIVE
  end

  def recipient=(recipient)
    raise "Recipient is not an Account." unless recipient.is_a?(Account)
    @recipient = recipient
  end

  def self.conversations(account)
    first_pms = PrivateMessage.select("MAX(private_messages.id) AS m_id").joins("INNER JOIN conversations ON conversations.id=conversation_id").where("first_account_id=? AND ISNULL(first_deleted_at)", account.id).group("conversation_id")
    second_pms = PrivateMessage.select("MAX(private_messages.id) AS m_id").joins("INNER JOIN conversations ON conversations.id=conversation_id").where("second_account_id=? AND ISNULL(second_deleted_at)", account.id).group("conversation_id")

    max_ids = first_pms.collect {|x| x.m_id}
    max_ids += second_pms.collect {|x| x.m_id}
    PrivateMessage.where("id IN (?)", max_ids).order("created_at DESC").includes(conversation: [:first_account, :second_account])
  end

  def self.conversation_detail(conversation, account)
    pms = conversation.private_messages
    if conversation.first_account == account
      pms = pms.where("ISNULL(first_deleted_at)")
    else
      pms = pms.where("ISNULL(second_deleted_at)")
    end
    pms.order("created_at DESC")
  end

  def self.read(conversation, account)
    if conversation.first_account == account
      PrivateMessage.where("private_message_type=? AND conversation_id=?", self::TYPE_RECEIVE, conversation.id).update_all(read_at: Time.now())
    else
      PrivateMessage.where("private_message_type=? AND conversation_id=?", self::TYPE_SEND, conversation.id).update_all(read_at: Time.now())
    end
  end

  def self.conversation_destroy(conversation, account)
    pms = PrivateMessage.where("conversation_id=?", conversation.id)
    if conversation.first_account = account
      pms.update_all(first_deleted_at: Time.now())
    else
      pms.update_all(second_deleted_at: Time.now())
    end
  end

  protected
  def default_values
    unless self.id
      self.conversation = Conversation.new
    end
  end

  def parse_conversation
    return false unless self.sender || self.recipient
    return false if self.sender == self.recipient

    if sender.id > recipient.id
      first = self.recipient
      second = self.sender
      self.private_message_type = self.class::TYPE_RECEIVE
    else
      first = self.sender
      second = self.recipient
      self.private_message_type = self.class::TYPE_SEND
    end

    conversation = Conversation.where("first_account_id=? AND second_account_id=?", first.id, second.id).first
    unless conversation
      conversation = Conversation.new
      conversation.first_account = first
      conversation.second_account = second
      conversation.save!
    end

    self.conversation = conversation
    true
  end
end
