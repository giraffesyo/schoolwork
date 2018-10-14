import React from 'react'
import styled from 'styled-components'
import firebase from '../firebase'
import localForage from 'localforage'
import { Redirect } from 'react-router-dom'

const CenteredDiv = styled.div`
  display: flex;
  flex-flow: column;
  justify-content: center;
  align-items: center;
  height: 100vh;
`
const StyledLogin = styled.div`
  padding: 1rem;
  button {
    color: white;
    padding: 0.5rem;
    border-radius: 5%;
    margin-left: auto;
    margin-right: 0.25rem;
    min-width: 45%;
  }
`

const LoginButton = styled.button`
  background-color: black;
`

const RegisterButton = styled.button`
  background-color: green;
`

const InputGroup = styled.div`
  width: 50%;
  margin: 0.5rem 0;
  input {
    padding: 0.5rem;
  }
`
const ForgotPasswordButton = styled.button`
  background-color: #fff;
  border: 0;
  color: blue !important;
`

class Login extends React.PureComponent {
  state = { username: '', password: '', users: [], loggedIn: false }

  async componentDidMount() {
    // check if user is logged in
    const loggedIn = !!(await localForage.getItem('user'))
    if (loggedIn) {
      // redirect to home by setting state to logged in
      this.setState({ loggedIn })
    }
    //add users to state
    const ref = await firebase
      .database()
      .ref('users')
      .once('value')
    const users = ref.val()
    this.setState({ users })
    console.log(users)
  }

  handleChangeUsername = event => {
    const username = event.target.value
    this.setState({ username })
  }
  handleChangePassword = event => {
    const password = event.target.value
    this.setState({ password })
  }
  handleSignUp = data => {
    const { username, password } = this.state
    const usersRef = firebase.database().ref('users')
    usersRef.child(username).set({ username, password })
    this.setState({ message: 'Registration Successful' })
    console.log('Registration successful')
  }
  handleLogin = async data => {
    const { username, password, users } = this.state
    console.log(`username: ${username}`)
    console.log(`password: ${password}`)
    if (username in users) {
      if (users[username].password === password) {
        //login
        await localForage.setItem('user', username)
      } else {
        this.setState({ message: 'Incorrect password.' })
      }
    } else {
      this.setState({ message: "Sorry, that user doesn't exist" })
    }
  }

  handleForgotPassword = data => {
    console.log('we are clicking the forget password')
    console.log(data)
  }

  render() {
    const {
      handleSignUp,
      handleLogin,
      handleForgotPassword,
      handleChangeUsername,
      handleChangePassword,
      state: { username, password, loggedIn }
    } = this
    return (
      <CenteredDiv>
        {loggedIn && <Redirect to="/home" />}
        <h1>Help 2 Be Helped</h1>
        <StyledLogin>
          <InputGroup>
            <input
              onChange={handleChangeUsername}
              value={username}
              placeholder="username"
            />
          </InputGroup>
          <InputGroup>
            <input
              onChange={handleChangePassword}
              value={password}
              type="password"
              placeholder="password"
            />
          </InputGroup>
          <RegisterButton onClick={handleSignUp}>Register</RegisterButton>
          <LoginButton onClick={handleLogin}>Login</LoginButton>
          <ForgotPasswordButton onClick={handleForgotPassword}>
            Forgot password?
          </ForgotPasswordButton>
        </StyledLogin>
      </CenteredDiv>
    )
  }
}

export { Login }
