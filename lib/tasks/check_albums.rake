namespace :account do
  desc "Check default ablums of all accounts."

  task fix_album: :environment do
    puts "Check missing ablums"

    default_ablum = Settings.albums.defaults.screenshot

    albums = []
    accounts = Account.joins("left join albums on account_id=accounts.id and albums.album_type=#{Album::TYPE_SCREENSHOT}").select("accounts.*, albums.id as album_id")

    accounts.each do |account|
      next if account.album_id

      album = Album.new(name: Settings.albums.defaults.screenshot)
      album.album_type = Album::TYPE_SCREENSHOT
      album.account_id = account.id

      albums << album
    end

    Album.import albums
  end
end
