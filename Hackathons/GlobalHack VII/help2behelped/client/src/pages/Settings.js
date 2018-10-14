import React from 'react'
import Layout from '../HOC/Layout'

import styled from 'styled-components'
import avatar from '../images/wolf-avatar.png'
import { ProfileTopNav } from '../blocks/ProfileTopNav'

import firebase from '../firebase'
import localForage from 'localforage'

const Avatar = styled.img`
  height: 100px;
  width: 100px;
`
class Settings extends React.PureComponent {
  state = { user: {}, loaded: false }
  async componentDidMount() {
    const username = (await localForage.getItem('user')) || 'test'

    const ref = await firebase
      .database()
      .ref('users')
      .once('value')
    const users = ref.val()
    const user = users[username]
    this.setState({ user, loaded: true })
  }

  render() {
    const { user, loggedIn } = this.state
    console.log(user)
    return (
      <Layout TopNav={ProfileTopNav}>
        <div className="container">
          <div className="col-lg-4 order-lg-1 text-center">
            <Avatar
              src={avatar}
              className="mx-auto img-fluid img-circle d-block"
              alt="avatar"
            />
          </div>
          <div className="col-md-6">
            <h5 className="mb-3">User Profile: {user.username}</h5>
            <h6>Stats:</h6>
            <span className="badge badge-primary">
              <i className="fa fa-user" /> 25 Points
            </span>
            <br />
            <span className="badge badge-success">
              <i className="fa fa-cog" /> Granted 19 Favors
            </span>
            <br />
            <span className="badge badge-danger">
              <i className="fa fa-eye" /> Recieved 3 Favors
            </span>
            <br />
            <hr />
            <h6>Recent badges</h6>
            <a href="#" className="badge badge-dark badge-pill">
              First Favor!
            </a>
            <a href="#" className="badge badge-dark badge-pill">
              Canine Caregiver
            </a>
            <a href="#" className="badge badge-dark badge-pill">
              Green Thumb
            </a>
            <a href="#" className="badge badge-dark badge-pill">
              Hercules (Helped 10 People Move)
            </a>
            <hr />
          </div>
          <div className="col-lg-8 order-lg-2">
            <div className="tab-content py-4">
              <div className="tab-pane active" id="profile">
                <div className="row">
                  <div className="col-md-6">
                    <h6>Info</h6>
                    <p>
                      I am a computer science student, my native language is
                      English, and I'm really advanced on javascript.
                    </p>
                    <h6>Services</h6>
                    <p>
                      Teaching javascript, teaching React, teaching Python,
                      practice your Spanish, teach you to cook japanse food.
                    </p>
                  </div>
                  <div className="col-md-12">
                    <h5 className="mt-2">
                      <span className="fa fa-clock-o ion-clock float-right" />
                      Speaks
                    </h5>
                    <table className="table table-sm table-hover table-striped">
                      <tbody>
                        <tr>
                          <td>
                            <strong>Spanish</strong>
                          </td>
                          <td>
                            <strong>Basic</strong>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <strong>English</strong>
                          </td>
                          <td>
                            <strong>Fluent</strong>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                  <div className="col-md-12">
                    <h5 className="mt-2">
                      <span className="fa fa-clock-o ion-clock float-right" />
                      Recent Activity
                    </h5>
                    <table className="table table-sm table-hover table-striped">
                      <tbody>
                        <tr>
                          <td>
                            Performed dogsitting for <strong>2 Favor</strong>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            Performed housekeeping for <strong>2 Favor</strong>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            Taught javascript for <strong>2 Favor</strong>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            Helped somebody move for <strong>2 Favor</strong>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
              <div className="tab-pane" id="messages">
                <table className="table table-hover table-striped">
                  <tbody>
                    <tr>
                      <td>
                        <span className="float-right font-weight-bold">
                          Yesterday
                        </span>{' '}
                        There has been a request on your account since that
                        was..
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <span className="float-right font-weight-bold">
                          9/10
                        </span>{' '}
                        Porttitor vitae ultrices quis, dapibus id dolor. Morbi
                        venenatis lacinia rhoncus.
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <span className="float-right font-weight-bold">
                          9/4
                        </span>{' '}
                        Vestibulum tincidunt ullamcorper eros eget luctus.
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <span className="float-right font-weight-bold">
                          9/4
                        </span>{' '}
                        Maxamillion ais the fix for tibulum tincidunt
                        ullamcorper eros.
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </Layout>
    )
  }
}

export { Settings }
