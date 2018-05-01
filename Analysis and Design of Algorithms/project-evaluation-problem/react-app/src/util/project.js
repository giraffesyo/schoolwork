class project {
  constructor(name, area) {
    this.name = name
    this.area = area
  }

  getAreaName() {
    const area = this.area
    switch (area) {
      case 0:
        return 'education'
      case 1:
        return 'health'
      case 2:
        return 'natural resources'
      case 3:
        return 'transportation'
      case 4:
        return 'traveling'
      case 5:
        return 'design'
      case 6:
        return 'technology'
      default:
        throw new Error('Incorrect area provided')
    }
  }

  getArea() {
    return this.area
  }

  setArea(area) {
    const previousArea = this.area
    this.area = area
    return previousArea
  }

  getName() {
    return this.name
  }

  setName(name) {
    const oldName = this.name
    this.name = name
    return oldName
  }
}

export { project }
