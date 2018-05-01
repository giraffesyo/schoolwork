class Project {
  /*
  Areas:
  1: education
  2: health
  3: natural resources
  4: transportation
  5: traveling
  6: design
  7: technology
  */

  constructor(area) {
    this.area = area
  }

  getAreaName() {
    const area = this.area
    switch (area) {
      case 1:
        return 'education'
        break
      case 2:
        return 'health'
        break
      case 3:
        return 'natural resources'
        break
      case 4:
        return 'transportation'
        break
      case 5:
        return 'traveling'
        break
      case 6:
        return 'design'
        break
      case 7:
        return 'technology'
        break
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
}

class Expert {
  constructor(area, capacity) {
    this.area = area //area of expertise
    this.capacity = capacity //number of projects expert can do
    this.projects = []
  }

  addProject(project) {
    if (this.projects.length < this.capacity)
      if (project.area === this.area) this.projects.push(project)
      else throw 'Unsupported project, user is not skilled in that area'
    else throw 'This user is over capacity'
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

  getCapacity() {
    return this.capacity
  }

  setCapacity(capacity) {
    const previousCapacity = this.capacity
    this.capacity = capacity
    return previousCapacity
  }

  getAreaName() {
    const area = this.area
    switch (area) {
      case 1:
        return 'education'
        break
      case 2:
        return 'health'
        break
      case 3:
        return 'natural resources'
        break
      case 4:
        return 'transportation'
        break
      case 5:
        return 'traveling'
        break
      case 6:
        return 'design'
        break
      case 7:
        return 'technology'
        break
    }
  }
}

const Cline = new Expert(7, 2)
const VideoGame = new Project(7)
const MobileApp = new Project(7)
const VacationPlan = new Project(5)

