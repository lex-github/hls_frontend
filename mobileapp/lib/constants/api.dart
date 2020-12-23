const siteUrl = 'https://hls-backend-stage.herokuapp.com/';
const apiUri = '${siteUrl}graphql';
const apiTokenKey = 'Client-Token';
const apiTokenValue = 'WcbKFUnrAteA3YyajbK8c68839j7TXXq';
const apiHeaders = {
  apiTokenKey: apiTokenValue,
  'Content-Type': 'application/json'
};

// types

const userFields = '{'
  'data '
  '{'
    'age '
    'gender '
    'weight '
  '} '
  'id '
  'name '
  'email '
  'phoneNumber '
  'activeDialogId '
  'finishedDialogs'
  '}';

const chatCardFields = '{'
  'key '
  'addons '
  'questionType '
  'questions '
  'answers '
  'style '
  'results'
  '}';

// query

const currentUserQuery = '''
  query {
    currentUser $userFields
  }
''';

// mutations

const authSignInMutation = '''
  mutation (
    \$login: String! 
    \$password: String!) {
    authSignIn(
      email: \$login 
      password: \$password 
      admin: false) {
      authToken
      user $userFields
    }
  }
''';

const authSignOutMutation = '''
  mutation {
    authSignOut {
      status
    }
  }
''';

const authSendOtpMutation = '''
  mutation (
    \$phone: String!) {
    authSendOtp(
      phoneNumber: \$phone) {
      status
    }
  }
''';

const authVerifyOtpMutation = '''
  mutation (
    \$code: String!
    \$phone: String!) {
    authVerifyOtp(
      code: \$code
      phoneNumber: \$phone) {
      authToken
      user $userFields
    }
  }
''';

const chatBotDialogStartMutation = '''
  mutation (
    \$name: String!) {
    chatBotDialogStart(
      name: \$name) {
      dialogId
      dialogStatus
      nextCard $chatCardFields
    }
  }
''';

const chatBotDialogResumeMutation = '''
  mutation (
    \$dialogId: ID!) {
    chatBotDialogResume(
      dialogId: \$dialogId) {
      dialogStatus
      nextCard $chatCardFields
    }
  }
''';