# Elm Auth0 universal login

This example has been adapted from https://auth0.com/blog/creating-your-first-elm-app-part-2/ and updated for elm 0.19. In particular we had to:
- Use the Browser module
- Update the scopes for retrieve to the email from the user profile

On the Auth0 side, make sure to update the redirect URI and enable the implicit grant type in the advanced settings. In index.html, update the domain and client ID.
