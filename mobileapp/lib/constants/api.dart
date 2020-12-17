const siteUrl = 'https://hls-backend-stage.herokuapp.com/';
const apiUri = '${siteUrl}graphql';
const apiTokenKey = 'Client-Token';
const apiTokenValue = 'WcbKFUnrAteA3YyajbK8c68839j7TXXq';
const apiHeaders = {
  apiTokenKey: apiTokenValue,
  'Content-Type': 'application/json'
};

// types

const userFields = '''
   {
    data {
      age
      gender
      weight
    }
    
    id
    name
    email
    phoneNumber
  }
''';

// query

const String currentUserQuery = '''
  query {
    currentUser $userFields
  }
''';

// mutations

const String authSignInMutation = '''
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