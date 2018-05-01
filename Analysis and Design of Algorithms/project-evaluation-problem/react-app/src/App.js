import React, { Component } from 'react'
import { Container, Row, Col, Alert } from 'reactstrap'

import { AddExpert } from 'components/AddExpert'
import { AddProject } from 'components/AddProject'
import 'App.css'

class App extends Component {
  state = { experts: [], projects: [], message: '', err: '' }

  addExpert = expert => {
    const { experts } = this.state
    this.setState({ experts: [...experts, expert] })
  }

  addProject = project => {
    const { projects } = this.state
    this.setState({ projects: [...projects, project] })
  }

  render() {
    const { addExpert, addProject } = this
    const { message, err } = this.state
    return (
      <Container>
        <Row>
          <Col>
            <Alert color={err}>{message}</Alert>
          </Col>
        </Row>
        <Row>
          <Col md={6}>
            <AddExpert addExpert={addExpert} />
          </Col>
          <Col md={6}>
            <AddProject addProject={addProject} />
          </Col>
        </Row>
      </Container>
    )
  }
}

export default App
