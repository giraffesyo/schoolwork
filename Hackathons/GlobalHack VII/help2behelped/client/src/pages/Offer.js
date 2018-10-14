import React from 'react'
import Layout from '../HOC/Layout'
import styled from 'styled-components'
import { FaPencilAlt } from 'react-icons/fa'
import { green } from '../colors'
import { Checkbox } from '../blocks/Checkbox'
import { SearchTopNav } from '../blocks/SearchTopNav'
import localForage from 'localforage'
import firebase from '../firebase'
import { Redirect } from 'react-router-dom'

const SearchStyles = styled.div`
  overflow-x: hidden;

  .lookingText {
    color: #60a084;
    font-size: 1.2em;
    margin-top: 10px;
  }

  .slider {
    -webkit-appearance: none;
    width: 100%;
    height: 5px;
    border-radius: 5px;
    background: ${green};
    outline: none;
    opacity: 0.7;
    -webkit-transition: 0.2s;
    transition: opacity 0.2s;
    margin-top: 10px;
  }

  .slider::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    width: 15px;
    height: 15px;
    border-radius: 50%;
    background: ${green};
    cursor: pointer;
  }

  .slider::-moz-range-thumb {
    width: 15px;
    height: 15px;
    border-radius: 50%;
    background: ${green};
    cursor: pointer;
  }

  .milesText {
    color: ${green};
    font-size: 1.2em;
    text-align: right;
  }

  .containerList ul {
    list-style: none;
    margin-top: 15px;
    margin-left: -25px;
  }

  .containerDate {
    color: ${green};
  }
`

const iniitialOptions = {
  Babysitting: false,
  Petcare: false,
  Housekeeping: false,
  Gardening: false,
  Teaching: false,
  Cooking: false,
  Elderly: false
}

const Header = styled.h3`
  display: inline-block;
  color: ${green};
  text-decoration: underline;
  margin-top: 2rem;
`

const Label = styled.label`
  color: ${green};
  font-size: 1.2em;
`

const Input = styled.input`
  border: 1px solid ${green};
`

const BigInput = styled.textarea`
  margin-top: 1rem;
  height: 60px;
  border: 1px solid ${green};
`

class Offer extends React.PureComponent {
  state = {
    options: {
      ...iniitialOptions
    },
    distance: 0,
    task: null,
    user: {}
  }

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

  handleChange = e => {
    const key = e.target.getAttribute('name')
    this.setState({
      task: key,
      options: { ...iniitialOptions, [key]: !this.state.options[key] }
    })
  }

  handleChangeDescription = e => {
    this.setState({ description: e.target.value })
  }

  handleSlide = e => {
    const distance = e.target.value
    this.setState({ distance })
  }

  makeOffer = async () => {
    const username = this.state.user.username
    const { task, description } = this.state
    //dont do it if we dont have both task and username
    console.log('here')
    if (!task || !username || !description) return
    const offersRef = firebase.database().ref('offers')
    offersRef.push({ user: username, task, description })
    this.setState({offered: true})
  }

  render() {
    const {
      handleSlide,
      handleChange,
      handleChangeDescription,
      state: { options, distance, description, offered },
      makeOffer
    } = this
    let Options = []
    for (let key in options) {
      Options.push(
        <div key={key}>
          <Checkbox name={key} onClick={handleChange} checked={options[key]} />
          <Label>{key}</Label>
        </div>
      )
    }
    return (

      <Layout>
        <SearchStyles>
          <div className="lookingText">I am offering ...</div>
          <div className="distanceForm">
            <form>
              <div className="form-group">
                <input
                  onChange={handleSlide}
                  type="range"
                  min="1"
                  max="10"
                  step="1"
                  value={distance}
                  className="form-control-range slider"
                  id="formControlRange"
                />
              </div>
            </form>
          </div>
          <div className="milesText">{distance} miles away</div>
          <div className="containerList">{Options}</div>
          <div className="containerDate row">
            <div className="col-7">
              <BigInput
                onChange={handleChangeDescription}
                value={description}
                placeholder="Put a description about your offer!"
              />
            </div>
            <div className="col-2">
              <Header onClick={makeOffer}>Offer</Header>
            </div>
          </div>
        </SearchStyles>
        {offered && <Redirect to='/search' />}
      </Layout>
    )
  }
}
export { Offer }
