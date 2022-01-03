const int userPointWidth = 150;
const int userPointHeight = 60;
const int space = 70;
const wSpace = userPointHeight / 2;

//////////////////////////////////////////////////////////////////////
const String tableUsers = 'users';
const String fieldId = 'id';
const String fieldToken = 'token';
const String fieldName = 'name';
const String fieldGender = 'gender';
const String fieldPhone = 'phone';
const String fieldEmail = 'email';
const String fieldDad = 'dad';
const String fieldMom = 'mom';
const String fieldSpouse = 'spouse';
const String fieldProfile = 'profile';
const String fieldLink = 'link';
/////////////////////////////////////////////////////////////////////

const String listSons = 'sons';

/// for shared preferences

//enum Gender { male, female }

/// for Posts
///
const String tablePosts = 'posts';
const String fieldPostId = 'post_id';
const String fieldPostOwnerId = 'owner_id';
const String fieldPostText = 'post_text';
const String fieldPostImagesUrls = 'post_images_urls';
const String fieldPostVideoUrl = 'post_video_url';
const String fieldPostCommentsIsd = 'post_comments_ids';
const String fieldPostSharesIds = 'post_shares_ids';
const String fieldPostLovesIds = 'post_loves_ids';
// const String fieldPostSadsIds = 'post_sads_ids';
// const String fieldPostAngriesIds = 'post_angries_ids';
// const String fieldPostCaresIds = 'post_cares_ids';
const String fieldPostTime = 'post_time';
//////////////////////////////////////////////////////////////
/// for Comments
///
const String tableComments = 'comments';
const String fieldCommentId = 'id';
const String fieldCommentTime = 'time';
const String fieldCommentOwner = 'owner';
const String fieldCommentText = 'text';
const String fieldCommentPostId = 'postId';
const String fieldCommentImage = 'image';
const String fieldCommentVideo = 'video';
const String fieldCommentLoves = 'loves';

/// for Replies
///
const String tableReplies = 'replies';
const String fieldReplyId = 'id';
const String fieldReplyOwner = 'owner';
const String fieldReplyCommentId = 'comment_id';
const String fieldReplyText = 'text';
const String fieldReplyImage = 'image';
const String fieldReplyVideo = 'video';
const String fieldReplyTime = 'time';
const String fieldReplyLoves = 'loves';

/// //////////////////////recommended posts//////////////////////////////
const String recommendedPosts = 'recommended_posts';

///  for messages
///
const String collectionMessages = 'Messages';
const String fieldMessageId = 'id';
const String fieldMessageChatId = 'chat_id';
const String fieldMessageSender = 'sender';
const String fieldMessageReceiver = 'receiver';
const String fieldMessageTime = 'time';
const String fieldMessageText = 'text';
const String fieldMessageVideo = 'video';
const String fieldMessageImage = 'image';
const String collectionChats = 'chats';
const String fieldChatId = 'id';

const String fieldChatUser1 = 'user1';
const String fieldChatUser2 = 'user2';

/// for notifications
///
const String collectionNotifications = ' notifications';
const String fieldNotificationId = 'id';
const String fieldNotificationUserId = 'user_id';
const String fieldNotificationOwnerId = 'owner_id';
const String fieldNotificationCommentId = 'comment_id';
const String fieldNotificationReplyId = 'reply_id';
const String fieldNotificationRelation = 'relation';
const String fieldNotificationAction = 'acton';
const String fieldNotificationPostId = 'post_id';
const String fieldNotificationTime = 'time';

///   requests
///
const String collectionRequests = 'requests';
const String fieldRequestId = 'id';
const String fieldRequestSenderId = 'sender';
const String fieldRequestUserId = 'user';
const String fieldRequestRelationId = 'relation';
const String fieldRequestTime = 'time';

const months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
final List<String> days = [for (int i = 1; i <= 31; i++) i.toString()];
final List<String> years = [
  for (int i = 1900; i <= DateTime.now().year; i++) i.toString()
];
