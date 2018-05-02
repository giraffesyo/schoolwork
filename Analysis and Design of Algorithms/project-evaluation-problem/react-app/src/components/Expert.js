import React from 'react'
import { Card, CardBody, CardTitle, CardText, Row, Col } from 'reactstrap'

/*
    this.area = area //area of expertise
    this.capacity = capacity //number of projects expert can do
    this.projects = []
    this.name = name
*/

class Expert extends React.PureComponent {
  render() {
    const { expert } = this.props
    const { projects, name } = expert
    return (
      <Card>
        <CardBody>
          <Row>
            <Col>
              <h5>{name}</h5>
            </Col>
            <Col xs={3}>
              {expert.getAssignedCount()}/{expert.getCapacity()}
            </Col>
          </Row>
          <Row>
            <Col>
              <ul>
                {projects.map((project, i) => (
                  <li key={`project-${i}`}>{project.getName()}</li>
                ))}
              </ul>
            </Col>
          </Row>
        </CardBody>
      </Card>
    )
  }
}

export { Expert }
