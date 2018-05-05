class Project {
  /*
  Areas:
  0: education
  1: health
  2: natural resources
  3: transportation
  4: traveling
  5: design
  6: technology
  */

  constructor(area) {
    this.area = area
  }

  getAreaName() {
    const area = this.area
    switch (area) {
      case 0:
        return 'education'
        break
      case 1:
        return 'health'
        break
      case 2:
        return 'natural resources'
        break
      case 3:
        return 'transportation'
        break
      case 4:
        return 'traveling'
        break
      case 5:
        return 'design'
        break
      case 6:
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
        break
      case 1:
        return 'health'
        break
      case 2:
        return 'natural resources'
        break
      case 3:
        return 'transportation'
        break
      case 4:
        return 'traveling'
        break
      case 5:
        return 'design'
        break
      case 6:
        return 'technology'
        break
    }
  }
}

Experts = [
  [new Expert(0, 1)],
  [],
  [],
  [],
  [],
  [],
  [new Expert(6, 2), new Expert(6, 10), new Expert(6, 3)],
]
Projects = [
  new Project(6),
  new Project(6),
  new Project(6),
  new Project(1),
  new Project(3),
]

function distributeProject(project) {
  const area = project.area
  const currentExperts = Experts[area]

  //Start at negative one and change if we find a candidate
  let candidate = -1
  //How many projects they have assigned divided by the capacity
  let currentCandidateScore = 1

  for (let i = 0; i < currentExperts.length; i++) {
    const totalCapacity = currentExperts[i].getCapacity()
    const availableCapacity = currentExperts[i].getAvailableCapacity()
    const assignedCount = currentExperts[i].getAssignedCount()
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
      if (newRatio < currentCandidateScore) {
        currentCandidateScore = newRatio
        candidate = i
      }
    }
  }

  //If we found a candidate, they are assigned the work
  if (candidate != -1) Experts[area][candidate].addProject(project)
  else throw 'no candidate found for project'
}
distributeProject(new Project(6))
distributeProject(new Project(6))
distributeProject(new Project(6))
distributeProject(new Project(6))

console.log(Experts)
console.log(Experts[6][0])
console.log(Experts[6][1])
console.log(Experts[6][2])
/*
const Cline = new Expert(7,2)
const TechP = new Project(7)
Cline.addProject(TechP)
console.log(Cline.getAvailableCapacity())*/
