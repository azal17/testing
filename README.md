# API Testing 

This repository contains automated API test cases for the [reqres.in](https://reqres.in) site. 

### Structure
- test: The test folder contains robot framework test cases covering the following scenarios:
  - List Users: Verify user list retrieval and response status and content
  - Single User: Get specific user details and validate response
  - Single User Not Found: Check 404 status for missing user
  - Create: Create a new user and verify 201
  - Update Put: Fully update user information
  - Update Patch: Partially update user information
  - Delete: Delete a user and confirm success
  - Registration Successful: Test valid user registration
  - Registration Unsuccessful: Incomplete registration
  - Login Successful: Test successful login and token retrieval
  - Login Unsuccessful: Check error on invalid login
  - Delay: Verify delayed response and measure delay time
     
- test suite: The test folder contains python test cases covering the same scenarios as above
