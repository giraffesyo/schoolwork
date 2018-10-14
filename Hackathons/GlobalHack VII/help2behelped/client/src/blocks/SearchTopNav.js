import React from 'react'
import styled from 'styled-components'
import { green } from '../colors'
import { FaPencilAlt } from 'react-icons/fa'

const TopNav = styled.div`
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  overflow-x: hidden;
  z-index: 1000;
  .greenBackground {
    height: 80px;
    background-color: ${green};
    padding: 30px 0 10px 10px;
    border-bottom-style: solid;
    border-bottom-color: #428266;
  }

  .round {
    width: 80%;
    border-radius: 10px;
    border: 1px #60a084 solid;
  }

  .pencil {
    color: white;
  }

  .filter {
    text-decoration: underline;
    font-size: 1.2em;
    letter-spacing: 1px;
  }
`

class SearchTopNav extends React.PureComponent {
  render() {
    return (
      <TopNav>
        <div className="container greenBackground">
          <div className="row">
            <div className="col-8">
              <div className="search">
                <input
                  type="text"
                  className="round"
                  id="search"
                  placeholder=" Search..."
                />
                <FaPencilAlt className="ml-3 pencil" />
              </div>
            </div>
            <div className="col-4 filter">Filter</div>
          </div>
        </div>
      </TopNav>
    )
  }
}

export { SearchTopNav }
