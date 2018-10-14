import React from 'react'
import Layout from '../HOC/Layout'
import styled from 'styled-components'
import { FaPencilAlt } from 'react-icons/fa'
import {green} from '../colors'
import { Checkbox } from '../blocks/Checkbox'

const SearchStyles = styled.div`
overflow-x: hidden;
.greenBackground {
    background-color: ${green};
    padding: 10px 0 10px 10px;
    border-bottom-style: solid;
    border-bottom-color: #428266;

}

.round
{
    width: 80%;
    border-radius: 10px;
    border: 1px #60a084 solid;
}

.pencil {
    color: white;
}

.filter
{
    text-decoration: underline;
    font-size: 1.2em;
    letter-spacing: 1px;
}

.lookingText
{
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
    -webkit-transition: .2s;
    transition: opacity .2s;
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

.milesText
{
    color: ${green};
    font-size: 1.2em;
    text-align: right;
}

.containerList ul 
{
list-style: none;
margin-top: 15px;
margin-left: -25px;
}


`


class Search extends React.PureComponent {
    
    state = {
        babysitting: false,
        petcare: false,
        housecleaning: false,
        gardening: false,
        teaching: false,
        cooking: false,
        elderlycare: false
    }
    
    handleChange = e => {
        this.setState({[e.target.name]: !this.state[e.target.name]})
    }
    
  render() {
      const {handleChange} = this
    return (
      <Layout>
        <SearchStyles>
            <div className="container greenBackground">
              <div className="row">
                <div className="col-8">
                    <div classname="search">
                        <input type="text" className="round" id="search" onkeyup="myFunction()" placeholder=" Search..." />
                        <FaPencilAlt className='ml-3 pencil' />
                    </div>
                </div>
                <div className="col-4 filter">
                    Filter
                </div>
              </div>
            </div>
            <div className="container distance">
                <div className="lookingText">
                    I am looking for
                </div>
                <div className="distanceForm">
                    <form>
                        <div className="form-group">
                            <input type="range" min="1" max="10" step="0.01"  className="form-control-range slider" id="formControlRange"/>
                        </div>
                    </form>
                </div>
                <div className="milesText">
                    5 miles away
                </div>
            </div>
            <div className="containerList">
                <label class="container">
  <input type="checkbox"/>One
  <span class="checkmark"></span>
</label>

<label class="container">
  <input type="checkbox"/>Two
  <span class="checkmark"></span>
</label>

<label class="container">
  <input type="checkbox"/>Three
  <span class="checkmark"></span>
</label>

<label class="container">
  <input type="checkbox"/>Four
  <span class="checkmark"></span>
</label>
            </div>
        </SearchStyles>
      </Layout>
    )
  }
}
export { Search }
