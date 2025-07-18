# Showcase Social App Server

A Swift backend for my upcoming Showcase Social App - basically Twitter for people who take their coffee way too seriously.

## What is this?

This is the server-side code for a simple social app I'm building to show off some of my Swift and SwiftUI skills. Think of it as a demo project that lets coffee addicts share their profound thoughts about lattes and existential dread in 250 characters or less :D

The actual app is coming very soon :)

## What it does

- Users can sign up and pretend their opinions about coffee matter
- JWT authentication because security is important, even for coffee thoughts
- Post creation and deletion
- Like/unlike system for social validation
- Profile photos for that personal touch
- Pagination for smooth browsing

## How to run this thing

You'll need Swift and a Mac. If you don't have those, this probably isn't for you.

```bash
git clone https://github.com/Dorothea9/ShowcaseSocialApp.git
cd ShowcaseSocialApp
swift run
```

The server will grudgingly start on `http://localhost:8080`

## API Documentation

Visit `http://localhost:8080/swagger` to see the interactive API docs where you can test every endpoint directly in your browser. The authentication system is fully functional - just register, login, grab your token, and start testing all the features. You can also check out the raw OpenAPI spec at `http://localhost:8080/swagger.yaml` if you prefer.

## The Routes

### Authentication Stuff
- `POST /auth/register` - Join the coffee cult
- `POST /auth/login` - Come back to the coffee cult
- `POST /auth/logout` - Temporarily leave the coffee cult
- `POST /auth/refresh` - Get a fresh token (like a fresh brew)

### User Things
- `GET /users/{userId}` - Stalk someone's profile
- `GET /users/{userId}/posts` - See all their coffee opinions
- `GET /users/{userId}/likes` - Judge their taste in other people's posts

### Post Management
- `GET /posts` - Read everyone's coffee thoughts
- `POST /posts` - Share your own coffee wisdom
- `DELETE /posts/{postId}` - Delete that embarrassing post about decaf

### Social Validation
- `POST /posts/{postId}/like` - Validate someone's coffee opinion
- `DELETE /posts/{postId}/like` - Withdraw your validation

### Profile Photos
- `PUT /profile-photo` - Upload your carefully curated coffee shop selfie
- `DELETE /profile-photo` - Go back to being faceless

## Authentication

Uses JWT tokens because apparently that's what the cool kids use. Stick your token in the Authorization header:

```
Authorization: Bearer <your-token-here>
```

Access tokens expire after 15 minutes (just like your coffee), refresh tokens last a week.

## Sample API Calls

Register yourself:
```bash
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "definitely.not.addicted@coffee.com",
    "firstName": "Definitely",
    "lastName": "NotAddicted",
    "password": "password123"
  }'
```

Share your thoughts:
```bash
curl -X POST http://localhost:8080/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your-token>" \
  -d '{
    "text": "Pineapple on pizza is wrong but oat milk in coffee is somehow fine?"
  }'
```

## Code Structure

The code is organized into routes because I'm not a monster:

- `AuthRoutes.swift` - All the login/logout stuff
- `UserRoutes.swift` - User profile nonsense
- `PostRoutes.swift` - The main event
- `LikeRoutes.swift` - Social validation mechanics
- `ProfilePhotoRoutes.swift` - Photo upload magic
- `StaticRoutes.swift` - Serves your beautiful face
- `SwaggerRoutes.swift` - API documentation

## Technical Details

- Built with Swift and Swifter
- Stores profile photos locally
- Secure password hashing
- Input validation and error handling
- JWT authentication with refresh tokens
- Pagination support

## About This Project

This is built to have backend for my Showcase App, both will be part of the portfolio.

## Contact

Dorota Belanová  
belanova.dorota@gmail.com  

Built with Swift, powered by caffeine, and self-doubt :D
