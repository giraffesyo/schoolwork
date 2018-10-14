import React from 'react'
import Layout from '../HOC/Layout'
import { ProfileTopNav } from '../blocks/ProfileTopNav'
import { FaEdit } from 'react-icons/fa'
import styled from 'styled-components'
import { green } from '../colors'
import EmptyProfile from '../images/edit_pic.jpg'

import localForage from 'localforage'
import firebase from '../firebase'
import { Redirect } from 'react-router-dom'

const Avatar = styled.img`
  height: 100px;
  width: 100px;
`
const Name = styled.h1`
  font-size: 2rem;
  display: inline;
`
const BioInfo = styled.div`
  text-align: center;
  border: solid;
  max-width: 45%;
  float: right;
  font-size: small;
`
const Input = styled.input`
  border: 1px solid ${green};
`

const BigInput = styled.textarea`
  margin-top: 1rem;
  height: 60px;
  border: 1px solid ${green};
`

const Header = styled.h3`
  display: inline;
  color: ${green};
  text-decoration: underline;
`

class EditProfile extends React.PureComponent {
  state = { loaded: false, user: {}, loggedIn: true }

  async componentDidMount() {
    const username = (await localForage.getItem('user')) || 'test'

    const ref = await firebase
      .database()
      .ref('users')
      .once('value')
    const users = ref.val()
    const user = users[username]
    this.setState({ user, loaded: true, username })
  }

  logout = () => {
    localForage.removeItem('user')
    this.setState({ loggedIn: false })
  }
  render() {
    const {
      state: { user, loaded, loggedIn },
      logout
    } = this
    console.log(user)
    return (
      <Layout TopNav={ProfileTopNav}>
        <div className="row">
          <div className="col-4">
            <Avatar src={EmptyProfile} className="img-fluid" />
          </div>

          <div className="col">
            {' '}
            <div className="row">
              <div className="col">
                <Name>{user.username}</Name> <FaEdit />
              </div>
            </div>{' '}
            <div className="row">
              <div className="col">
                <BigInput placeholder="Enter your bio info here" />
              </div>
            </div>
          </div>
          <div className="row mt-4 ml-1">
            <div className="col">
              <div className="row">
                <div className="col">
                  <Header>Change Photo</Header>
                </div>
              </div>
              <div className="row">
                <div className="col-11 mt-1">
                  This photo will not be available to anyone but moderators, we
                  need this information in order to keep you save.
                </div>
                <div className="col mt-2 col-sm-4">
                  <Header>Languages</Header>
                </div>
              </div>
            </div>
          </div>

          <div className="row mt-5 ml-1">
            <div className="col">
              <Header>Change Password</Header>
            </div>
          </div>
          <div className="row mt-5 ml-1">
            <div className="col-12">
              <Header onClick={logout}>Logout</Header>
              {!loggedIn && <Redirect to="/" />}
            </div>
          </div>
        </div>
      </Layout>
    )
  }
}

export { EditProfile }
