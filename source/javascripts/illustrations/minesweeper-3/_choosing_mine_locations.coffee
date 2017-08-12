#= require ../../_illustration_registry
#= require vendor/physics
#= require vendor/svg

CELL_VELOCITIES = [
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
  { x: 7.4, y: -7.1 },
  { x: 6.1, y: -6.8 },
  { x: 5.8, y: -6.2 },
  { x: 5.5, y: -5.5 },
  { x: 5.0, y: -5.0 },
  { x: 4.5, y: -4.5 },
  { x: 4.0, y: -4.0 },
  # 27
  { x: 5.0, y: -4.7 },
  { x: 4.6, y: -4.7 },
  { x: 4.4, y: -4.7 },
  { x: 4.0, y: -4.5 },
  { x: 3.5, y: -4.5 },
  { x: 3.2, y: -4.3 },
  { x: 2.8, y: -4.3 },
  { x: 2.4, y: -4 },
  { x: 2.2, y: -3.8 },
  # 36
  { x: 5.5, y: -4.6 },
  { x: 4.7, y: -4.9 },
  { x: 4.4, y: -4.8 },
  { x: 3.8, y: -5.2 },
  { x: 3.4, y: -5.2 },
  { x: 3.0, y: -5.4 },
  { x: 2.5, y: -5.3 },
  { x: 2.2, y: -5.5 },
  { x: 1.8, y: -5.5 },
]

class SvgObject
  constructor: ({ @svgElement, mass = 1 }) ->
    @element = @svgElement.node
    @particle = new Physics.Particle(mass)
    @_originalX = @svgElement.x()
    @_originalY = @svgElement.y()
    @_width = @svgElement.bbox().width
    @_height = @svgElement.bbox().height
    @_debug = false
    @_offset = { x: 0, y: 0, width: 0, height: 0 }
    @_updates = []

  reset: =>
    if @_originalOffset?
      @_offset = @_originalOffset
      @_originalOffset = null
    @particle.position.set(@_originalX, @_originalY)
    @_updateBounds()
    return this

  update: =>
    @_updateBounds()
    @_render()
    @_updates.forEach (update) -> update()
    return this

  onUpdate: (fn) =>
    @_updates.push(fn)

  freezeInPlace: =>
    @particle.velocity.clear()
    @particle.fixed = true
    return this

  isInside: (object) =>
    @bounds.x1 >= object.bounds.x1 && @bounds.x2 <= object.bounds.x2 &&
      @bounds.y1 >= object.bounds.y1 && @bounds.y2 <= object.bounds.y2

  hasFallenBelow: (object) =>
    @bounds.y1 > object.bounds.y2

  putIn: (parent) =>
    @svgElement.putIn(parent)
    return this

  offsetBy: (x, y) =>
    @_originalOffset = _.clone(@_offset)
    @_offset.x = x
    @_offset.y = y
    @particle.position.addSelf(new Physics.Vector(-x, -y))
    @_updateBounds()
    return this

  _updateBounds: =>
    @bounds = @_determineBounds()
    #console.log(@constructor.name, "bounds:", @bounds.x1, @bounds.x2, ",", @bounds.y1, @bounds.y2)
    @_drawBounds()

  _determineBounds: =>
    x1 = @particle.position.x + @_offset.x
    y1 = @particle.position.y + @_offset.y
    width = @_width + @_offset.width
    height = @_height + @_offset.height
    x2 = x1 + width
    y2 = y1 + height
    {
      x1: x1
      x2: x2
      y1: y1
      y2: y2
      cx: (x1 + x2) / 2
      cy: (y1 + y2) / 2
      width: width
      height: height
    }

  _drawBounds: =>
    if @_debug
      @boundsBox ?= @svgElement.doc().rect(0, 0).style(stroke: "red")
      @boundsBox.move(@bounds.x1, @bounds.y1).size(@bounds.width, @bounds.height)

  _render: =>
    @svgElement.x(@particle.position.x)
    @svgElement.y(@particle.position.y)

class Hat extends SvgObject
  constructor: ({ @svgElement }) ->
    super({ @svgElement })
    @layer2 = @svgElement.select(".hat-layer2").first()
    @particle.makeFixed()
    @_offset = { x: 55, y: 55, width: -105, height: -85 }

  relayer: (object) =>
    object.putIn(@layer2).offsetBy(@svgElement.x(), @svgElement.y())
    return this

class Cell extends SvgObject
  constructor: ({ @svgElement, @boardElement, @hat, @root, @index }) ->
    super({ @svgElement })
    @particle.makeFixed()

  reset: =>
    super()
    @boardElement.put(@svgElement)
    return this

  applyForce: =>
    @hat.relayer(this)
    @particle.fixed = false
    desiredVelocity = @_determineDesiredVelocity()
    @particle.velocity.set(desiredVelocity.x, desiredVelocity.y)
    return this

  update: =>
    super()
    if @isInside(@hat)
      @freezeInPlace()
    return this

  _determineDesiredVelocity: =>
    #x = @_determineDesiredXVelocity()
    #y = @_determineDesiredYVelocity(x)
    CELL_VELOCITIES[@index]

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
    @objects = @cells
    @physics = @_buildPhysics()

  play: =>
    _.invokeMap(@objects, "reset")
    @promiseOnEquilibrium =
      then: (fn) ->
        if @isResolved
          fn()
        else
          @callback = fn
      resolve: ->
        @callback?()
        @isResolved = true
    @_applyForces(@objects.slice(18, 27))
    @physics.play()
    @promiseOnEquilibrium

  pause: =>
    @physics.pause()
    @promiseOnEquilibrium.resolve()

  _determineBounds: =>
    width = @svg.bbox().width
    height = @svg.bbox().height
    {
      x1: 0
      x2: width
      y1: 0
      y2: height
      width: width
      height: height
    }

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
      @pause()

  _applyForces: (objects) =>
    _.invokeMap(objects, "applyForce")
    #if objects.length > 0
      #objects[0].applyForce()
      #setTimeout =>
        #@_applyForces(objects.slice(1))
      #, 50

mcmire.me.illustrationRegistry.register(
  "choosing-mine-locations",
  ChoosingMineLocations
)
