import React from 'react'
import Layout from '../HOC/Layout'
import styled from 'styled-components'
import { FaPencilAlt } from 'react-icons/fa'
import { green } from '../colors'
import { Checkbox } from '../blocks/Checkbox'
import { SearchTopNav } from '../blocks/SearchTopNav'

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
`

class Search extends React.PureComponent {
  state = {
    options: {
      Babysitting: false,
      Petcare: false,
      Housekeeping: false,
      Gardening: false,
      Teaching: false,
      Cooking: false,
      Elderly: false
    }
  }

  handleChange = e => {
    console.log(e)
    console.log(e.target.getAttribute('name'))
    const key = e.target.getAttribute('name')
    this.setState({
      options: { ...this.state.options, [key]: !this.state.options[key] }
    })
  }

  render() {
    const {
      handleChange,
      state: { options }
    } = this
    let Options = []
    for (let key in options) {
      Options.push(
        <div key={key}>
          <Checkbox name={key} onClick={handleChange} checked={options[key]} />
          <label>{key}</label>
        </div>
      )
    }
    return (
      <Layout TopNav={SearchTopNav}>
        <SearchStyles>
            <div className="lookingText">I am looking for</div>
            <div className="distanceForm">
              <form>
                <div className="form-group">
                  <input
                    type="range"
                    min="1"
                    max="10"
                    step="0.01"
                    className="form-control-range slider"
                    id="formControlRange"
                  />
                </div>
              </form>
            </div>
            <div className="milesText">5 miles away</div>
          <div className="containerList">{Options}</div>
        </SearchStyles>
      </Layout>
    )
  }
}
export { Search }
