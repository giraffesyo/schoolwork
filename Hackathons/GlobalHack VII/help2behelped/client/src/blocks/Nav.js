import React from "react"
import { Link } from "react-router-dom"
import styled from "styled-components"
import {
  FaCog,
  FaGlobeAmericas,
  FaSearch,
  FaHandHoldingHeart
} from "react-icons/fa"

const NavBar = styled.nav`
  background: #8ac4ab;
  display: flex;
  flex-flow: row;
  justify-content: space-around;
  align-items: center;
  position: fixed;
  height: 80px;
  bottom: 0;
  width: 100%;
  z-index: 1000;
  opacity: 0.9;
`

const Option = styled.div`
  flex-basis: 0.25;
  color: white;
  font-size: 2rem;
  padding: 0.25rem;
`

class Nav extends React.PureComponent {
  render() {
    return (
      <NavBar>
        <Link to="/home">
          <Option>
            <FaGlobeAmericas />
          </Option>
        </Link>
        <Link to="/search">
          <Option>
            <FaSearch />
          </Option>
        </Link>
        <Link to="/offer">
          <Option>
            <FaHandHoldingHeart />
          </Option>
        </Link>
        <Link to="/settings">
          <Option>
            <FaCog />
          </Option>
        </Link>
      </NavBar>
    )
  }
}

export { Nav }
