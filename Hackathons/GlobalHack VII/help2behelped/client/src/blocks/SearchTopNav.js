import React from "react"
import styled from "styled-components"
import { green } from "../colors"
import { FaPencilAlt } from "react-icons/fa"
import { Link } from "react-router-dom"

const TopNav = styled.div`
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  overflow-x: hidden;
  z-index: 1000;

  .greenBackground {
    height: 80px;
    background-color: #bde3d3;
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
    font-size: 1.2rem;
    letter-spacing: 1px;
  }
  a {
    color: #60a083 !important;
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
              </div>
            </div>
            <div className="col-4 filter">
              <Link to="/searchfilter">Filter</Link>
            </div>
          </div>
        </div>
      </TopNav>
    )
  }
}

export { SearchTopNav }
