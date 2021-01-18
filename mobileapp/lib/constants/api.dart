const siteUrl = 'https://hls-backend-stage.herokuapp.com/';
const apiUri = '${siteUrl}graphql';
const apiTokenKey = 'Client-Token';
const apiTokenValue = 'WcbKFUnrAteA3YyajbK8c68839j7TXXq';
const apiHeaders = {
  apiTokenKey: apiTokenValue,
  'Content-Type': 'application/json'
};

// types

const userFields =
  '{'
    'data '
    '{'
      'age '
      'gender '
      'weight'
    '} '
    'id '
    'name '
    'email '
    'phoneNumber '
    'chatBotDialogs'
    '{'
      'id '
      'name '
      'status'
    '}'
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

const foodCategoryGeneral =
  'id '
  'title '
  'icon '
  '{'
    'url'
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
    'structure '
    '{'
      'key '
      'quantity '
      'section '
      'title '
      'unit '
    '}'
  '}';

// query

const currentUserQuery = 'query '
  '{'
    'currentUser $userFields'
  '}';

const foodCategoriesQuery = 'query '
  '{'
    'foodCategories $foodCategoryListFields'
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
    '$foodFields'
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
      'dialogStatus '
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
      'dialogStatus '
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
      'dialogResult '
      'dialogStatus '
      'nextCard $chatCardFields'
    '}'
  '}';