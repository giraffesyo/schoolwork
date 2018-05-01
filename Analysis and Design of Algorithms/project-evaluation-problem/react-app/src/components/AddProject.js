import React from 'react'
import {
  Row,
  Col,
  Form,
  FormGroup,
  Label,
  Input,
  Button,
  Card,
  CardBody,
  CardTitle,
} from 'reactstrap'

import { project } from 'util/project'

class AddProject extends React.PureComponent {
  state = { name: '', area: '' }

  handleNameChange = e => {
    const name = e.target.value
    this.setState({ name })
  }

  handleAreaChange = e => {
    const area = parseInt(e.target.value, 10)
    this.setState({ area })
  }

  render() {
    const { handleNameChange, handleAreaChange } = this
    const { name, area } = this.state
    const { addProject } = this.props
    return (
      <Card className="addCard">
        <CardBody>
          <CardTitle>Add Project</CardTitle>
          <Form>
            <FormGroup>
              <Row>
                <Col md={4}>
                  <Label for="name">Name: </Label>
                </Col>
                <Col>
                  <Input
                    value={name}
                    onChange={handleNameChange}
                    id="name"
                    placeholder="Expert's Name"
                  />
                </Col>
              </Row>
            </FormGroup>
            <FormGroup>
              <Row>
                <Col md={4}>
                  <Label for="area">Area: </Label>
                </Col>
                <Col>
                  <Input
                    value={area}
                    onChange={handleAreaChange}
                    id="area"
                    type="select"
                  >
                    <option value="0">Education</option>
                    <option value="1">Health</option>
                    <option value="2">Natural Resources</option>
                    <option value="3">Transportation</option>
                    <option value="4">Travel</option>
                    <option value="5">Design</option>
                    <option value="6">Technology</option>
                  </Input>
                </Col>
              </Row>
            </FormGroup>
            <Button
              onClick={() => addProject(new project(name, area))}
              style={{ float: 'right' }}
              color="success"
            >
              Add Expert
            </Button>
          </Form>
        </CardBody>
      </Card>
    )
  }
}

export { AddProject }
