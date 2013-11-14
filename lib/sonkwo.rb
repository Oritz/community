require 'sonkwo/behavior'
require 'sonkwo/post_type'

# configurate behaviors
#Sonkwo::Behavior.register :talks, class_name: 'Talk'
#Sonkwo::Behavior.register :subjects, class_name: 'Subject'
#Sonkwo::Behavior.register :recommends, class_name: 'Recommend'
#Sonkwo::Behavior.register :comments, class_name: 'Comment'
Sonkwo::Behavior.register :posts, class_name: 'Post'

# configurate posts
Sonkwo::PostType.regist_submodel :talk, class_name: 'Talk', post_type: Post::TYPE_TALK
Sonkwo::PostType.regist_submodel :subject, class_name: 'Subject', post_type: Post::TYPE_SUBJECT
Sonkwo::PostType.regist_submodel :recommend, class_name: 'Recommend', post_type: Post::TYPE_RECOMMEND
