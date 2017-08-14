#= require ../../_illustration_registry
#= require vendor/physics
#= require vendor/svg

# Yes, this took forever...
OPENING_CELL_VELOCITIES = [
  # 0
  { x: 7.5, y: -8.0 },
  { x: 7.0, y: -7.7 },
  { x: 6.5, y: -7.0 },
  { x: 6.0, y: -6.5 },
  { x: 5.7, y: -6.0 },
  { x: 5.5, y: -5.5 },
  { x: 5.0, y: -5.0 },
  { x: 4.5, y: -4.5 },
  { x: 4.0, y: -4.0 },
  # 9
  { x: 7.8, y: -7.7 },
  { x: 7.2, y: -7.4 },
  { x: 6.9, y: -7.1 },
  { x: 6.4, y: -6.8 },
  { x: 5.8, y: -6.2 },
  { x: 5.5, y: -5.5 },
  { x: 5.0, y: -5.0 },
  { x: 4.5, y: -4.5 },
  { x: 4.0, y: -4.0 },
  # 18
  { x: 8.3, y: -7.7 },
  { x: 7.7, y: -7.4 },
  { x: 7.5, y: -7.1 },
  { x: 7.0, y: -6.8 },
  { x: 6.4, y: -6.2 },
  { x: 6.1, y: -5.5 },
  { x: 5.5, y: -5.0 },
  { x: 5.0, y: -4.5 },
  { x: 4.5, y: -4.0 },
  # 27
  { x: 8.8, y: -7.7 },
  { x: 8.2, y: -7.4 },
  { x: 8.0, y: -7.1 },
  { x: 7.5, y: -6.8 },
  { x: 6.9, y: -6.2 },
  { x: 6.6, y: -5.5 },
  { x: 6.0, y: -5.0 },
  { x: 5.5, y: -4.5 },
  { x: 5.0, y: -4.0 },
  # 36
  { x: 9.3, y: -7.7 },
  { x: 8.7, y: -7.4 },
  { x: 8.5, y: -7.1 },
  { x: 8.0, y: -6.8 },
  { x: 7.6, y: -6.2 },
  { x: 7.3, y: -5.5 },
  { x: 6.7, y: -5.0 },
  { x: 6.2, y: -4.5 },
  { x: 5.7, y: -4.0 },
  # 45
  { x: 9.3, y: -8.6 },
  { x: 8.7, y: -8.3 },
  { x: 8.5, y: -8.0 },
  { x: 8.0, y: -7.7 },
  { x: 7.6, y: -7.1 },
  { x: 7.3, y: -6.6 },
  { x: 6.7, y: -6.4 },
  { x: 6.0, y: -6.2 },
  { x: 5.3, y: -6.0 },
  # 54
  { x: 9.3, y: -9.4 },
  { x: 8.7, y: -9.3 },
  { x: 8.1, y: -9.2 },
  { x: 7.4, y: -9.0 },
  { x: 6.7, y: -8.8 },
  { x: 6.0, y: -8.6 },
  { x: 5.3, y: -8.4 },
  { x: 4.6, y: -8.2 },
  { x: 3.9, y: -8.0 },
  # 63
  { x: 9.1, y: -10.3 },
  { x: 8.5, y: -10.2 },
  { x: 7.9, y: -10.0 },
  { x: 7.3, y: -9.9 },
  { x: 6.7, y: -9.8 },
  { x: 6.1, y: -9.8 },
  { x: 5.5, y: -9.6 },
  { x: 4.9, y: -9.4 },
  { x: 4.3, y: -9.2 },
  # 72
  { x: 8.9, y: -11.2 },
  { x: 8.3, y: -11.1 },
  { x: 7.7, y: -11.0 },
  { x: 7.1, y: -10.9 },
  { x: 6.5, y: -10.8 },
  { x: 5.9, y: -10.8 },
  { x: 5.3, y: -10.6 },
  { x: 4.2, y: -10.8 },
  { x: 3.6, y: -11.1 },
]

CLOSING_CELL_VELOCITIES = [
  { x: 3.0, y: -5.0, closingXLimit: 600, closingYLimit: 40 },
  { x: 5.0, y: -11.0, closingXLimit: 700, closingYLimit: 40 },
  { x: 6.0, y: -11.0, closingXLimit: 800, closingYLimit: 40 },
  { x: 7.0, y: -11.0, closingXLimit: 900, closingYLimit: 40 },
  { x: 5.0, y: -12.0, closingXLimit: 900, closingYLimit: 40 },
  { x: 5.5, y: -12.5, closingXLimit: 700, closingYLimit: 40 },
  { x: 6.0, y: -13.0, closingXLimit: 750, closingYLimit: 40 },
  { x: 6.5, y: -13.5, closingXLimit: 800, closingYLimit: 40 },
  { x: 7.0, y: -14.0, closingXLimit: 850, closingYLimit: 40 },
  { x: 7.5, y: -14.5, closingXLimit: 900, closingYLimit: 40 },
]

class Bounds
  constructor: ({ topLeft, bottomRight }) ->
    @topLeft = topLeft
    @bottomRight = bottomRight
    @_recalculate()

  clone: =>
    new @constructor({
      topLeft: @topLeft.clone(),
      bottomRight: @bottomRight.clone()
    })

  moveBy: (vector) =>
    @topLeft.addSelf(vector)
    @bottomRight.addSelf(vector)
    @_recalculate()
    return this

  isInside: (bounds) =>
    @x1 >= bounds.x1 && @x2 <= bounds.x2 &&
      @y1 >= bounds.y1 && @y2 <= bounds.y2

  isBottomInside: (bounds) =>
    @x1 >= bounds.x1 && @x2 <= bounds.x2 &&
      @y2 >= bounds.y1 && @y2 <= bounds.y2

  isLeftInside: (bounds) =>
    @x1 >= bounds.x1 && @x1 <= bounds.x2 &&
      @y1 >= bounds.y1 && @y2 <= bounds.y2

  isRightInside: (bounds) =>
    @x2 >= bounds.x1 && @x2 <= bounds.x2 &&
      @y1 >= bounds.y1 && @y2 <= bounds.y2

  wasEverInside: (bounds, previousBounds) =>
    console.log("bounds", bounds.x1, bounds.x2, bounds.y1, bounds.y2)
    console.log("previousBounds", previousBounds.x1, previousBounds.x2, previousBounds.y1, previousBounds.y2)
    console.log("x, y:", @x1, @x2, @y1, @y2)

    if @isInside(bounds)
      true
    else
      halfwayToBounds =
        @bottomRight.clone().
        subSelf(previousBounds.bottomRight).
        divideScalar(2).
        negate()
      if halfwayToBounds.length() > 0.5
        @clone().moveBy(halfwayToBounds).wasEverInside(bounds, previousBounds)
      else
        false

  _recalculate: =>
    @topRight = new Physics.Vector(@bottomRight.x, @topLeft.y)
    @bottomLeft = new Physics.Vector(@topLeft.x, @bottomRight.y)
    @x1 = @topLeft.x
    @x2 = @topRight.x
    @y1 = @topLeft.y
    @y2 = @bottomLeft.y
    @width = @x2 - @x1
    @height = @y2 - @y1
    @cx = (@x1 + @x2) / 2
    @cy = (@y1 + @y2) / 2

class SvgObject
  constructor: ({ @svgElement, mass = 1 }) ->
    @element = @svgElement.node
    @particle = new Physics.Particle(mass)
    @_originalX = @svgElement.x()
    @_originalY = @svgElement.y()
    @_width = @svgElement.bbox().width
    @_height = @svgElement.bbox().height
    @_debug = false
    @offset = { x: 0, y: 0, width: 0, height: 0 }
    @_updates = []

  reset: =>
    if @_originalOffset?
      @offset = @_originalOffset
      @_originalOffset = null
    @particle.position.set(@_originalX, @_originalY)
    @_updateBounds()
    return this

  update: =>
    @_updateBounds()
    @render()
    @_updates.forEach (update) -> update()
    @previousBounds = @bounds.clone()
    return this

  onUpdate: (fn) =>
    @_updates.push(fn)

  freezeInPlace: =>
    @particle.velocity.clear()
    @particle.fixed = true
    return this

  isInside: (object) =>
    @bounds.isInside(object.bounds) || (
      @previousBounds? &&
      @previousBounds.isBottomInside(object.bounds) &&
      @bounds.isLeftInside(object.bounds)
    )

  ensureInside: (object) =>
    diffInX1 = (@bounds.x1 - object.bounds.x1)
    diffInX2 = (@bounds.x2 - object.bounds.x2)
    diffInY1 = (@bounds.y1 - object.bounds.y1)
    diffInY2 = (@bounds.y2 - object.bounds.y2)

    xOffset =
      if diffInX1 < 0
        diffInX1
      else if diffInX2 > 0
        -diffInX2
      else
        0

    yOffset =
      if diffInY1 < 0
        diffInY1
      else if diffInY2 > 0
        -diffInY2
      else
        0

    if Math.abs(xOffset) > 0 || Math.abs(yOffset) > 0
      @moveBy(xOffset, yOffset)

  hasFallenBelow: (object) =>
    @bounds.y1 > object.bounds.y2

  putIn: (parent) =>
    @svgElement.putIn(parent)
    return this

  moveTo: (x, y) =>
    @particle.position.set(x, y)
    @_updateBounds()
    return this

  moveBy: (x, y) =>
    @particle.position.addSelf(new Physics.Vector(x, y))
    @_updateBounds()
    return this

  offsetBy: (x, y) =>
    @_originalOffset = _.clone(@offset)
    @offset.x = x
    @offset.y = y
    @particle.position.addSelf(new Physics.Vector(-x, -y))
    @_updateBounds()
    return this

  affix: =>
    @particle.fixed = true

  _updateBounds: =>
    @bounds = @_determineBounds()
    @_drawBounds()

  _determineBounds: =>
    x1 = @particle.position.x + @offset.x
    y1 = @particle.position.y + @offset.y
    width = @_width + @offset.width
    height = @_height + @offset.height
    new Bounds(
      topLeft: new Physics.Vector(x1, y1),
      bottomRight: new Physics.Vector(x1 + width, y1 + height)
    )

  _drawBounds: =>
    if @_debug
      @boundsBox ?= @svgElement.doc().rect(0, 0).style(stroke: "red")
      @boundsBox.move(@bounds.x1, @bounds.y1).size(@bounds.width, @bounds.height)

  render: =>
    @svgElement.x(@particle.position.x)
    @svgElement.y(@particle.position.y)

class Hat extends SvgObject
  constructor: ({ @svgElement }) ->
    super({ @svgElement })
    @layer2 = @svgElement.select(".hat-layer2").first()
    @particle.makeFixed()
    @offset = { x: 55, y: 50, width: -108, height: -85 }
    @isSliding = false

  relayer: (object) =>
    object.putIn(@layer2).offsetBy(@svgElement.x(), @svgElement.y())
    return this

  slideLeft: =>
    @particle.fixed = false
    @particle.velocity.set(-20, 0)
    @isSlidingLeft = true
    return this

  stopSlidingLeft: =>
    @isSlidingLeft = false

  update: =>
    super()
    if @isSlidingLeft
      @particle.velocity.multiplySelf(new Physics.Vector(0.95, 0))
    return this

class Cell extends SvgObject
  constructor: ({ @svgElement, @boardElement, @hat, @root, @index }) ->
    super({ @svgElement })
    @particle.makeFixed()
    @state = null

  reset: =>
    super()
    @boardElement.put(@svgElement)
    @svgElement.select("rect").first().style(fill: "white")
    @svgElement.select("text").first().style(fill: "black")
    return this

  jumpIntoHat: =>
    @state = "jumpingIntoHat"
    @hat.relayer(this)
    @particle.fixed = false
    desiredVelocity = @_determineDesiredVelocity()
    @particle.velocity.set(desiredVelocity.x, desiredVelocity.y)
    return this

  jumpOutOfHat: (index) =>
    @state = "jumpingOutOfHat"
    @svgElement.select("rect").first().style(fill: "black")
    @svgElement.select("text").first().style(fill: "white")
    @particle.fixed = false
    @moveTo(@hat.offset.x, @hat.offset.y)
    velocity = CLOSING_CELL_VELOCITIES[index]
    console.log("particle position", @particle.position.x, @particle.position.y)
    @particle.velocity.set(velocity.x, velocity.y)
    @closingXLimit = velocity.closingXLimit
    @closingYLimit = velocity.closingYLimit
    return this

  render: =>
    if @state == "jumpingIntoHat" && @isInside(@hat)
      @ensureInside(@hat)
      @freezeInPlace()
    #if @state == "jumpingOutOfHat"
      #diff = @bounds.y2 - @root.bounds.y2
      #if diff > 0
        #@particle.position.y -= diff
        #@particle.velocity.multiplySelf(new Physics.Vector(0.3, -0.3))
        #if @particle.velocity.length() < 0.5
          #@freezeInPlace()
      #if @bounds.y1 >= @closingYLimit && @bounds.x1 >= @closingXLimit
        #@freezeInPlace()
    super()
    return this

  _determineDesiredVelocity: =>
    #x = @_determineDesiredXVelocity()
    #y = @_determineDesiredYVelocity(x)
    OPENING_CELL_VELOCITIES[@index]

  # FIXME: this doesn't work
  _determineDesiredXVelocity: =>
    numerator = (
      @root.gravity *
      @_yDistance() *
      @bounds.y1
    )
    denominator = 2 * Math.pow(@_xDistance(), 2)
    a = numerator / denominator
    b = -1
    c = 1
    (-b - Math.sqrt(Math.pow(b, 2) - 4 * a * c)) / (2 * a)

  # FIXME: this doesn't work
  _determineDesiredYVelocity: (xVelocity) =>
    term1 = (@_yDistance() * xVelocity) / @_xDistance()
    term2 = (@root.gravity * @_xDistance()) / (2 * xVelocity)
    term1 - term2

  _yDistance: =>
    @hat.bounds.cy - @bounds.cy

  _xDistance: =>
    @hat.bounds.cx - @bounds.cx

class ChoosingMineLocations
  constructor: ({ @element }) ->
    @gravity = 0.3
    @yLimit = -5
    @svg = SVG(@element)
    @bounds = @_determineBounds()
    @hat = @_buildHat(@svg.select(".hat").first())
    @boardElement = @svg.select(".board").first()
    @cells = @_buildCells(@boardElement, @hat, @svg.select(".cell"))
    @objects = [@hat].concat(@cells)
    @physics = @_buildPhysics()

  play: =>
    _.invokeMap(@objects, "reset")
    @_playPlaceCellsInHatAnimation()
      .then(@_playSlideHatAndCellsOverAnimation)

  pause: =>
    @physics.pause()
    @resolvePromise?()

  _determineBounds: =>
    width = @svg.bbox().width
    height = @svg.bbox().height
    new Bounds(
      topLeft: new Physics.Vector(0, 0),
      bottomRight: new Physics.Vector(width, height)
    )

  _buildHat: (svgElement) =>
    hat = new Hat({ svgElement })
    hat.reset()
    hat

  _buildCells: (boardElement, hat, svgSet) =>
    cells = []
    root = this
    svgSet.each (index) ->
      cell = new Cell(
        root: root,
        svgElement: this,
        boardElement: boardElement,
        hat: hat,
        index: index,
      )
      cells.push(cell)
    cells

  _buildPhysics: =>
    @physics = new Physics(@gravity)
    @physics.optimize(true)
    _.each @objects, (object) =>
      @physics.addParticle(object.particle)
      object.onUpdate =>
        if object.hasFallenBelow(this)
          @pause()
    @physics.onUpdate =>
      _.invokeMap(@objects, "update")
    @physics.onEquilibrium =>
      console.log("equilibrium hit")
      @pause()

  _playPlaceCellsInHatAnimation: =>
    @_playAnimation =>
      @_placeCellsInHat(_.shuffle(@cells))

  _playSlideHatAndCellsOverAnimation: =>
    @_playAnimation delay: 800, =>
      @physics.setGravity(0, 0)
      @hat.slideLeft()
      setTimeout =>
        @hat.affix()
        #@physics.setGravity(0, @gravity)
        shuffledCells = _.shuffle(@cells).slice(0, 1)
        attractionParticle = @physics.makeParticle(10, 400, 100)
        attractionParticle.makeFixed()
        _.each shuffledCells, (cell) =>
          @physics.makeAttraction(attractionParticle, cell.particle, 100000, 30)
        @_popCellsOutOfHat(shuffledCells)
      , 1400

  _placeCellsInHat: (cells) =>
    if cells.length > 0
      _.invokeMap(cells.slice(0, 3), "jumpIntoHat")
      requestAnimationFrame =>
        @_placeCellsInHat(cells.slice(3))

  _popCellsOutOfHat: (cells, index = 0) =>
    if cells.length > 0
      cells[0].jumpOutOfHat(index)
      requestAnimationFrame =>
        @_popCellsOutOfHat(cells.slice(1), index + 1)

  _playAnimation: (args...) =>
    fn = args.pop()
    { delay = 0 } = args[0] ? {}
    new Promise (resolve, reject) =>
      wrapperFn = =>
        @resolvePromise = resolve
        fn()
        @physics.play()
      if delay > 0
        setTimeout(wrapperFn, delay)
      else
        wrapperFn()

mcmire.me.illustrationRegistry.register(
  "choosing-mine-locations",
  ChoosingMineLocations
)
