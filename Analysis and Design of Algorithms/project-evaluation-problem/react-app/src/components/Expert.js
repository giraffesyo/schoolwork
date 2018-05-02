import React from 'react'
import { Card, CardBody, CardTitle, CardText, Row, Col } from 'reactstrap'

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
            <Col md={4}>
              {projects.length}/{expert.capacity}
            </Col>
          </Row>
          <Row>
            <Col>
              <ul>
                {projects.map((project, i) => (
                  <li key={`project-${i}`}>{project.name}</li>
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
