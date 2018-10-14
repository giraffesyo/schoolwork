import React from 'react'
import Layout from '../HOC/Layout'
import { ProfileTopNav } from '../blocks/ProfileTopNav'
import {FaEdit}from 'react-icons/fa'
import styled from 'styled-components'
import { bold } from 'ansi-colors';


const StyleName = styled.div`
font-size: medium;
text-align: right;
margin: .5rem;
`
const BioInfo = styled.div`
text-align: center;
border: solid;
max-width: 45%;
float: right;
font-size: small;
`



class EditProfile extends React.PureComponent {
  render() {
    return (
      <Layout TopNav={ProfileTopNav}>
        <div className="container">
          <div className="row">
            <div className="col">
              <StyleName>Giraffesyo <FaEdit /></StyleName>
            </div>
            <div ClassName="col">
            <BioInfo>Hi! I'm a senior programmer at OSU and bla bla bla</BioInfo>
            </div>
          </div>
          <div className="row">
            <div className="col">
              <h2></h2>
            </div>
          </div>
        </div>
      </Layout>
    )
  }
}

export { EditProfile }
