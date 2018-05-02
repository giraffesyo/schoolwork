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
    const { experts } = this.state
    const area = project.getArea()

    if (!project.getName()) {
      const message = 'Please enter a project name.'
      const err = 'danger'
      this.setState({ message, err })
      return
    } else if (area === '') {
      const message = 'Please choose an expertise area for your project.'
      const err = 'danger'
      this.setState({ message, err })
    } else if (experts[area].length === 0) {
      const message = 'Please add an expert first.'
      const err = 'danger'
      this.setState({ message, err })
    } else {
      this.distributeProject(project)
    }
  }

  distributeProject(project) {
    const area = project.area
    const { experts } = this.state
    const currentExperts = experts[area]

    //Start at negative one and change if we find a candidate
    let candidate = -1
    //How many projects they have assigned divided by the capacity
    let currentCandidateScore = 1

    for (let i = 0; i < currentExperts.length; i++) {
      const totalCapacity = currentExperts[i].capacity
      const assignedCount = currentExperts[i].projects.length
      const availableCapacity = totalCapacity - assignedCount
      //Continue if this expert already has maximum capacity
      if (availableCapacity === 0) continue
      //If they have no projects at all, they automatically receive the work
      if (assignedCount === 0) {
        candidate = i
        break
      } else {
        //At this point we know they have capacity and have at least one job already
        let ratioUnit = 1 / totalCapacity //.1 if you have capacity of 10
        let ratio = assignedCount * ratioUnit //.2 if you have 2
        let newRatio = ratio + ratioUnit //.3 following above two examples
        //if we have a smaller ratio then this is our new candidate
        if (newRatio <= currentCandidateScore) {
          currentCandidateScore = newRatio
          candidate = i
        }
      }
    }

    //If we found a candidate, they are assigned the work
    if (candidate !== -1) {
      const newExperts = [
        ...experts.slice(0, area),
        [
          ...experts[area].slice(0, candidate),
          {
            ...experts[area][candidate],
            projects: [...experts[area][candidate].projects, project],
          },
          ...experts[area].slice(candidate + 1),
        ],
        ...experts.slice(area + 1),
      ]
      console.log(newExperts)
      this.setState({
        experts: newExperts,
        err: 'success',
        message: `Project successfully distributed to ${experts[area][
          candidate
        ].name}.`,
      })
    } else
      this.setState({
        err: 'warning',
        message: 'No candidate found for this project',
      })
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
