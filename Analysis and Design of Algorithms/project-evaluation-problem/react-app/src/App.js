import React, { Component } from 'react'
import { Container, Row, Col, Alert } from 'reactstrap'

import { AddExpert } from 'components/AddExpert'
import { AddProject } from 'components/AddProject'
import { Area } from 'components/Area'
import 'App.css'

class App extends Component {
  state = {
    experts: [[], [], [], [], [], [], []],
    projects: [],
    message: '',
    err: '',
  }

  addExpert = expert => {
    const { experts } = this.state
    const area = expert.getArea()

    if (!expert.getName()) {
      const message = 'Please enter a name.'
      const err = 'danger'
      this.setState({ message, err })
      return
    } else if (expert.getArea() === '') {
      const message = 'Please choose an area of expertise.'
      const err = 'danger'
      this.setState({ message, err })
    } else if (expert.getCapacity() < 0) {
      const message = `Capacity cannot be negative, choose zero instead.`
      const err = 'danger'
      this.setState({ message, err })
    } else {
      const message = `Successfully added ${expert.name}.`
      const err = 'success'
      const newExperts = [
        ...experts.slice(0, area),
        [...experts[area], expert],
        ...experts.slice(area + 1),
      ]
      this.setState({ experts: newExperts, err, message })
    }
  }

  addProject = project => {
    const { projects } = this.state

    if (!project.getName()) {
      const message = 'Please enter a project name.'
      const err = 'danger'
      this.setState({ message, err })
      return
    } else if (!project.getArea()) {
      const message = 'Please choose an expertise area for your project.'
      const err = 'danger'
      this.setState({ message, err })
    } else {
      const message = `Successfully added the project: ${project.name}.`
      const err = 'success'
      this.setState({ projects: [...projects, project], err, message })
    }
  }

  render() {
    const { addExpert, addProject } = this
    const { message, err, experts } = this.state

    const names = [
      'Education',
      'Health',
      'Natural Resources',
      'Transportation',
      'Travel',
      'Design',
      'Technology',
    ]
    return (
      <Container>
        <Row className="mt-2">
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
        {experts.map((currentExperts, i) => (
          <Row key={names[i]} className="mt-2">
            <Col>
              <Area area={names[i]} experts={currentExperts} />
            </Col>
          </Row>
        ))}
      </Container>
    )
  }
}

export default App
