import React from "react"
import styled from "styled-components"
import { Link } from "react-router-dom"
import { green } from "../colors"
import Color from "color"

const NavBar = styled.nav`
  background: #bde3d3;
  display: flex;
  flex-flow: row;
  justify-content: space-around;
  align-items: center;
  position: fixed;
  top: 0;
  width: 100%;
  height: 80px;
  z-index: 1000;
  border-bottom: solid 2px #60a184;
`

const Option = styled.div`
  flex-basis: 0.25;
  color: #60a083;
  font-size: 1.2rem;
  padding: 0.25rem;
  text-decoration-color: ${Color(green)
    .darken(0.2)
    .string()};
`

class ProfileTopNav extends React.PureComponent {
  render() {
    return (
      <NavBar>
        <Link to="/settings">
          <Option>Profile</Option>
        </Link>
        <Link to="/messages">
          <Option>Messages</Option>
        </Link>
        <Link to="/editprofile">
          <Option>Edit</Option>
        </Link>
      </NavBar>
    )
  }
}

export { ProfileTopNav }
