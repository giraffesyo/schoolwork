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
import { expert } from 'util/expert'

class AddExpert extends React.PureComponent {
  state = { name: '', area: -1, capacity: 0 }

  handleNameChange = e => {
    const name = e.target.value
    this.setState({ name })
  }

  handleAreaChange = e => {
    const area = parseInt(e.target.value,10)
    this.setState({ area })
  }

  handleCapacityChange = e => {
    const capacity = parseInt(e.target.value,10)
    this.setState({capacity})
  }

  render() {
    const { handleNameChange, handleAreaChange, handleCapacityChange } = this
    const { name, area, capacity } = this.state
    const { addExpert } = this.props
    return (
      <Card className="addCard">
        <CardBody>
          <CardTitle>Add Expert</CardTitle>

          <Form>
            <FormGroup>
              <Row>
                <Col md={4}>
                  <Label for="name">Name: </Label>
                </Col>
                <Col>
                  <Input
                    onChange={handleNameChange}
                    value={name}
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
                    onChange={handleAreaChange}
                    value={area}
                    id="area"
                    type="select"
                  >
                    <option value="-1" disabled hidden>
                      Please select Expert's area
                    </option>
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
            <FormGroup>
              <Row>
                <Col md={4}>
                  <Label for="capacity">Project Capacity: </Label>
                </Col>
                <Col>
                  <Input
                    id="capacity"
                    type="number"
                    onChange={handleCapacityChange}
                    value={capacity}
                  />
                </Col>
              </Row>
            </FormGroup>
            <Button
              onClick={() => addExpert(new expert(name, area, capacity))}
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

export { AddExpert }
