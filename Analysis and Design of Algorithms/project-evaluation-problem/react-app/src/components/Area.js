import React from 'react'
import { Card, CardTitle, CardBody, Row, Col } from 'reactstrap'
import { Expert } from 'components/Expert'

class Area extends React.PureComponent {
  render() {
    //const experts = [new expert('Michael', 6, 2), new expert('Josh', 6, 2)]
    ///console.log(`Area is: ${experts[0].getArea()}` )
    //experts[0].addProject(new project('Codecademy', 6))
    //experts[0].addProject(new project('Codecademy', 6))
    const { experts } = this.props
    return (
      <Card>
        <CardBody>
          <h4>Education</h4>
          <Row>
            {experts.map((expert, i) => (
              <Col key={`expert-${i}`} md={3}>
                <Expert expert={expert} />
              </Col>
            ))}
          </Row>
        </CardBody>
      </Card>
    )
  }
}

export { Area }
