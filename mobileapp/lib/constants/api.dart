const siteUrl = 'https://hls-backend-stage.herokuapp.com/';
//const siteUrl = 'http://213.183.48.100:3000/';
const apiUri = '${siteUrl}graphql';
const apiTokenKey = 'Client-Token';
const apiTokenValue = 'WcbKFUnrAteA3YyajbK8c68839j7TXXq';
const apiHeaders = {
  apiTokenKey: apiTokenValue,
  'Content-Type': 'application/json'
};
const authTokenKey = 'Auth-Token';

// http path

const avatarUploadPath = 'upload';

// graphql types

const userCommonFields = ''
  'todaySchedule $scheduleFields'
  'data '
  '{'
    //'name '
    'age '
    'birthDate '
    'gender '
    'weight '
    'height'
  '} '
  'dailyRating '
  '{'
    'activity '
    'eating '
    'mode'
  '} '
  'id '
  'photoUrl '
  'email '
  'phoneNumber';

const userHealthLevelField =
  '{'
    'percent '
    //'value'
  '}';

const userFields =
  '{'
    '$userCommonFields '
    'weeklyTrainings '
    'progress '
    '{'
      'agesDiagram '
      'goal '
      'health '
      '{'
        'adaptiveCapacity $userHealthLevelField '
        'functionalityIndex $userHealthLevelField '
        'historyValues '
        '{'
          'avgRating '
          'formulasRating '
          'hlsApplication '
          'createdAt'
        '} '
        'hlsApplication '
        'queteletIndex $userHealthLevelField '
        'robinsonIndex $userHealthLevelField '
        'rufierProbe $userHealthLevelField '
        'debugInfo'
      '} '
      'macrocycle '
      'microcycle '
      '{'
        'number '
        'completedTrainings '
        'totalTrainings'
      '}'
    '} '
    'chatBotDialogs '
    '{'
      'id '
      'name '
      'status'
    '}'
  '}';

const uploadFields =
  '{'
    //'blobId '
    //'headers '
    'signedBlobId '
    'url'
  '}';

const chatBotDialogCommonFields =
  //'chatBot $chatBotFields '
  'id '
  'name '
  'status '
  'result';

const chatBotDialogHistoryFields =
  '{'
    '$chatBotDialogCommonFields '
    'history $chatBotHistoryFields'
  '}';

const chatBotDialogFields =
  '{'
    '$chatBotDialogCommonFields '
    'user $userFields'
  '}';

const chatBotFields =
  '{'
    ''
  '}';

const chatBotHistoryFields =
  '{'
    'order '
    'question '
    'answer'
  '}';

const chatCardFields =
  '{'
    'key '
    'addons '
    'questionType '
    'questions '
    'answers '
    'style '
    'results'
  '}';

const postFields =
  '{'
    'id '
    'title '
    'text '
    'imageUrl '
    'kind '
    'isHalf '
    //'isFavourite '
    'publishedAt '
    'stories '
    '{'
      'id '
      'imageUrl '
      'text'
    '}'
    'videoDuration '
    'videoUrl'
  '}';

const iconFields =
  'icon '
  '{'
    'url'
  '}';

const foodCategoryGeneral =
  'id '
  'title '
  '$iconFields';

const foodFiltersListFields =
  '{'
    'key '
    'title '
    'section '
    'values '
    //'filters'
  '}';

const foodCategoryListFields =
  '{'
    '$foodCategoryGeneral'
  '}';

const foodCategoryFields =
  '{'
    '$foodCategoryGeneral'
    //'parentCategory $foodCategoryListFields'
    'subcategories $foodSubcategoryFields'
    'foods $foodFields'
  '}';

const foodSubcategoryFields =
  '{'
    '$foodCategoryGeneral'
    //'parentCategory $foodCategoryListFields'
    'subcategories $foodSubcategory2Fields'
    'foods $foodFields'
  '}';

const foodSubcategory2Fields =
  '{'
    '$foodCategoryGeneral'
    //'parentCategory $foodCategoryListFields'
    'subcategories $foodSubcategory3Fields'
    'foods $foodFields'
  '}';

const foodSubcategory3Fields =
  '{'
    '$foodCategoryGeneral'
    //'parentCategory $foodCategoryListFields'
    'foods $foodFields'
  '}';

const foodFields =
  '{'
    'id '
    'title '
    '$iconFields '
    // 'structure '
    // '{'
    //   'key '
    //   'quantity '
    //   'section '
    //   'title '
    //   'unit '
    // '} '
    'foodCategory $foodCategoryListFields '
    'championOn'
  '}';

const foodFullFields =
  '{'
    'id '
    'title '
    '$iconFields '
    'structure '
    '{'
      'key '
      'quantity '
      'section '
      'title '
      'unit '
    '} '
    'foodCategory $foodCategoryListFields '
    'championOn'
  '}';

const scheduleFields =
  '{'
    'items $scheduleItemFields '
    'yesterdayAsleepTime'
  '}';

const scheduleItemFields =
  '{'
    'id '
    'kind '
    'plannedAt'
  '}';

// query

const currentUserQuery = 'query '
  '{'
    'currentUser $userFields'
  '}';

const chatHistoryQuery = 'query '
  '{'
    'currentUser '
    '{'
      'chatBotDialogs $chatBotDialogHistoryFields'
    '}'
  '}';

const dailyRatingTipQuery = 'query '
  '('
    '\$type: DailyRatingTipKind'
  ')'
  '{'
    'dailyRatingTip '
    '('
      'kind: \$type'
    ') '
    '{'
      'text'
    '}'
  '}';

const postsQuery = 'query '
  '{'
    'posts '
    '{'
      'nodes $postFields '
      'pageInfo '
      '{'
        'endCursor '
        'hasNextPage'
      '}'
    '}'
  '}';

const foodCategoriesQuery = 'query '
  '{'
    'foodCategories $foodCategoryListFields'
  '}';

const foodFilterQuery = 'query '
  '{'
    'foodFiltersList '
    '$foodFiltersListFields'
  '}';

const foodCategoryQuery = 'query '
  '('
    '\$id: ID!'
  ')'
  '{'
    'foodCategory '
    '('
      'id: \$id'
    ') '
    '$foodCategoryFields'
  '}';

const foodQuery = 'query '
  '('
    '\$id: ID!'
  ')'
  '{'
    'food '
    '('
      'id: \$id'
    ') '
    '$foodFullFields'
  '}';

const foodsQuery = 'query '
  '('
    '\$search: String '
    '\$filters: Json'
  ')'
  '{'
    'foods '
    '('
      'search: \$search '
      'filters: \$filters'
    ') '
    '$foodFullFields'
  '}';

// mutations

const authSignInMutation = 'mutation'
    '('
      '\$login: String! '
      '\$password: String!'
    ') '
    '{'
      'authSignIn'
      '('
        'email: \$login '
        'password: \$password '
        'admin: false'
      ') '
      '{'
        'authToken '
        'user $userFields'
      '}'
    '}';

const authSignOutMutation = 'mutation '
  '{'
    'authSignOut'
    '{'
      'status'
    '}'
  '}';

const authSendOtpMutation = 'mutation '
  '('
    '\$phone: String!'
  ') '
  '{'
    'authSendOtp'
    '('
      'phoneNumber: \$phone'
    ') '
    '{'
      'status'
    '}'
  '}';

const authVerifyOtpMutation = 'mutation'
  '('
    '\$code: String! '
    '\$phone: String!'
  ') '
  '{'
    'authVerifyOtp'
    '('
      'code: \$code '
      'phoneNumber: \$phone'
    ') '
    '{'
      'authToken '
      'user $userFields'
    '}'
  '}';

const chatBotDialogStartMutation = 'mutation'
  '('
    '\$name: String!'
  ') '
  '{'
    'chatBotDialogStart'
    '('
      'name: \$name'
    ') '
    '{'
      'dialogId '
      'nextCard $chatCardFields'
    '}'
  '}';

const chatBotDialogResumeMutation = 'mutation'
  '('
    '\$dialogId: ID!'
  ') '
  '{'
    'chatBotDialogResume'
    '('
      'dialogId: \$dialogId'
    ') '
    '{'
      'dialog $chatBotDialogHistoryFields '
      'nextCard $chatCardFields'
    '}'
  '}';

const chatBotDialogContinueMutation = 'mutation'
  '('
    '\$dialogId: ID! '
    '\$key: ID! '
    '\$values: [String!]!'
  ') '
  '{'
    'chatBotDialogContinue'
    '('
      'dialogId: \$dialogId '
      'answer: '
      '{'
        'key: \$key '
        'values: \$values'
      '}'
    ') '
    '{'
      'dialog $chatBotDialogFields '
      'nextCard $chatCardFields'
    '}'
  '}';

const schedulesCreateMutation = 'mutation'
  '('
    '\$asleepTime: String! '
    '\$wakeupTime: String! '
    '\$trainingTime: String'
  ') '
  '{'
    'schedulesCreate'
    '('
      'yesterdayAsleepTime: \$asleepTime '
      'wakeUpTime: \$wakeupTime '
      'trainingTime: \$trainingTime'
    ') '
    '{'
      'schedule $scheduleFields'
    '}'
  '}';

const usersToggleWeeklyTrainingMutation = 'mutation'
  '('
    '\$day: Int!'
  ') '
  '{'
    'usersToggleWeeklyTraining'
    '('
      'weekDay: \$day'
    ') '
    '{'
      'user $userFields'
    '}'
  '}';

const usersUpdateProfileMutation = 'mutation'
  '('
    '\$name: String '
    //'\$gender: ID '
    '\$birthDate: String '
    '\$height: Int '
    '\$weight: Int'
  ') '
  '{'
    'usersUpdateProfile'
    '('
      'updatedParams: '
      '{'
        'name: \$name '
        //'gender: \$gender '
        'birthDate: \$birthDate '
        'height: \$height '
        'weight: \$weight'
      '}'
    ') '
    '{'
      'user $userFields'
    '}'
  '}';

const createDirectUploadMutation = 'mutation'
  '('
    '\$filename: String! '
    '\$byteSize: Int! '
    '\$checksum: String! '
    '\$contentType: String!'
  ') '
  '{'
    'createDirectUpload'
    '('
      'input: '
      '{'
        'filename: \$filename '
        'byteSize: \$byteSize '
        'checksum: \$checksum '
        'contentType: \$contentType'
      '}'
    ') '
    '{'
      'directUpload $uploadFields'
    '}'
  '}';