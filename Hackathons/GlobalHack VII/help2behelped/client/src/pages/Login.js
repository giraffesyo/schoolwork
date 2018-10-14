import React from "react"
import styled from "styled-components"
import firebase from "../firebase"
import localForage from "localforage"
import { Redirect } from "react-router-dom"

const CenteredDiv = styled.div`
  display: flex;
  flex-flow: column;
  justify-content: center;
  align-items: center;
`
const StyledLogin = styled.div`
  padding: 1rem;

  color: white;
  padding: 0.5rem;
  border-radius: 5%;
  margin-left: auto;
  margin-right: 0.25rem;
  min-width: 45%;
`

const LoginButton = styled.button`
  background-color: #fff7ed;
  padding: 0.3rem;
  border-radius: 5%;
  margin-left: auto;
  margin-right: 0.1rem;
  min-width: 35%;
  border-style: solid;
  border-color: #60a084;
  border-width: 2px;
  color: #60a084;
  margin: 1rem;
`

const RegisterButton = styled.button`
  background-color: #fff7ed;
  padding: 0.3rem;
  border-radius: 5%;
  margin-left: auto;
  margin-right: 0.1rem;
  min-width: 35%;
  border-style: solid;
  border-color: #526e83;
  border-width: 2px;
  color: #526e83;
  margin: 1rem;
`

const InputGroup = styled.div`
  margin: 0.5rem 1rem;
  display: flex;
  flex-direction: column;
  input {
    padding: 0.5rem;
    flex-basis: 1;
  }
`
const ForgotPasswordButton = styled.button`
  background-color: #fff;
  border: 0;
  color: blue !important;
`
const BackgroundCol = styled.div`
  background-color: #fff7ed;
`
const StyledTitle = styled.div`
  margin-top: 10rem;
  margin-bottom: 2rem;
  color: #526d83;
  font-size: 2rem;
`
const StyledText = styled.div`
  color: #526d83;
  font-size: 1rem;
  text-align: center;
  margin: 1rem;
`
class Login extends React.PureComponent {
  state = { username: "", password: "", users: [], loggedIn: false }

  async componentDidMount() {
    // check if user is logged in
    const loggedIn = !!(await localForage.getItem("user"))
    if (loggedIn) {
      // redirect to home by setting state to logged in
      this.setState({ loggedIn })
    }
    //add users to state
    const ref = await firebase
      .database()
      .ref("users")
      .once("value")
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
    const usersRef = firebase.database().ref("users")
    usersRef.child(username).set({ username, password })
    this.setState({ message: "Registration Successful" })
    console.log("Registration successful")
  }
  handleLogin = async data => {
    const { username, password, users } = this.state
    console.log(`username: ${username}`)
    console.log(`password: ${password}`)
    if (username in users) {
      if (users[username].password === password) {
        //login
        await localForage.setItem("user", username)
      } else {
        this.setState({ message: "Incorrect password." })
      }
    } else {
      this.setState({ message: "Sorry, that user doesn't exist" })
    }
  }

  handleForgotPassword = data => {
    console.log("we are clicking the forget password")
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
      <BackgroundCol>
        <CenteredDiv>
          {loggedIn && <Redirect to="/home" />}
          <StyledTitle>Help 2 Be Helped</StyledTitle>
          <StyledText>
            We are trying to help immigrants around the world to feel at home by
            creating a community and connections with people that live around
            you
          </StyledText>
          <StyledText>
            Helping others in order to receive help is what we believe in. We
            want you to feel safe and create connections, that’s why we take
            privacy and safety very seriously. We ask you to upload a photo of
            yourself, but NO ONE but H2BH moderators will see in order to verify
            accounts and make this service safer
          </StyledText>
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
      </BackgroundCol>
    )
  }
}

export { Login }
