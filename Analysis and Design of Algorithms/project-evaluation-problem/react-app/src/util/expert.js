class expert {
  constructor(name, area, capacity) {
    this.area = area //area of expertise
    this.capacity = capacity //number of projects expert can do
    this.projects = []
    this.name = name
  }

  addProject(project) {
    if (this.projects.length < this.capacity) {
      console.log(project.getArea())
      if (project.getArea() === this.area) {
        this.projects.push(project)
      } else {
        throw new Error('Unsupported project, user is not skilled in that area')
      }
    } else throw new Error('This user is over capacity')
  }

  getProjects() {
    return this.projects
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

  getAvailableCapacity() {
    return this.getCapacity() - this.getProjects().length
  }

  getCapacity() {
    return this.capacity
  }

  getAssignedCount() {
    return this.getCapacity() - this.getAvailableCapacity()
  }

  setCapacity(capacity) {
    const previousCapacity = this.capacity
    this.capacity = capacity
    return previousCapacity
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
}

export { expert }
