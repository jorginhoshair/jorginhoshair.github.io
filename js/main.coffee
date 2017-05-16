---
---

$ = (selector) ->
	document.querySelectorAll(selector)
_ = (nodeList, fn) ->
	if fn
		Array.prototype.map.call(nodeList, fn)
	else
		Array.prototype.slice.call(nodeList)
Element.prototype.prependChild = (child) ->
	this.insertBefore child, this.firstChild



navbar = $('.site-header')[0]

navigate = (e) ->

	if e.target.href
		e.preventDefault()
		fixbarOffset = navbar.getBoundingClientRect().height
		target = e.target.attributes.href.nodeValue.toString()
		return if not target
		sectionTarget = $(target)[0] or $('a[name=' + target.substr(1) + ']')[0]
		if sectionTarget
			scrollTarget = sectionTarget.offsetTop - fixbarOffset
			scrollToY scrollTarget, 500, 'easeInOutQuint', () -> 
				false


_( $('a[href^="#"]') ).forEach (link) ->
	link.addEventListener 'click', navigate



Slider = (selector) ->
	return new Slider(selector) if not (this instanceof Slider)
	items = _( $ selector )
	slider = 
		items   : items
		index   : 0
		current : items[0]
		prev    : items[items.length-1]
		next    : items[1]
		playId  : undefined
		each    : (fn) ->
			if typeof fn is 'function'
				this.items.forEach fn
		select  : (index) ->
			if this.items[index]?
				this.index = index
				this.current = this.items[index]
				this.prev = this.items[index-1] or this.items[this.items.length-1]
				this.next = this.items[index+1] or this.items[0]
				this.compose()
			else
				throw new Error('Item selecionado não existe!')
		compose : () ->
			this.each (item, i, obj) ->
				item.classList.remove 'slider-current'
				item.classList.remove 'slider-prev'
				item.classList.remove 'slider-next'
			this.current.classList.add 'slider-current' if this.current?
			this.prev.classList.add 'slider-prev' if this.prev?
			this.next.classList.add 'slider-next' if this.next?
		Prev  : () ->
			if this.index is 0
				this.select this.items.length-1
			else
				this.select this.index-1
		Next  : () ->
			if this.index is this.items.length-1
				this.select 0
			else
				this.select this.index+1
		Play  : () ->
			that = this
			this.playId = setInterval () ->
				that.Next()
			, 3000
		Pause : () ->
			clearInterval this.playId
		RenderControls : (container) ->
			controls = document.createElement 'div'
			controls.className = 'slider-controls'
			controls.innerHTML = '<a class="control icon prev" href="#"></a><a class="control icon next" href="">avançar</a>'
			controlPrev = controls.querySelector '.control.prev'
			controlNext = controls.querySelector '.control.next'
			container.prependChild controls
			controlPrev.innerHTML = '<svg version="1.1" viewBox="0 0 59.414 59.414" width="60" height="60"><polygon fill="#48A0DC" points="43.854,59.414 14.146,29.707 43.854,0 45.268,1.414 16.975,29.707 45.268,58 	"/></svg>'
			controlPrev.addEventListener 'click', (e) ->
				e.preventDefault()
				slides.Prev()
			controlNext.innerHTML = '<svg version="1.1" viewBox="0 0 59.414 59.414" width="60" height="60"><polygon fill="#48A0DC" points="15.561,59.414 14.146,58 42.439,29.707 14.146,1.414 15.561,0 45.268,29.707 	"/></svg>'
			controlNext.addEventListener 'click', (e) ->
				e.preventDefault()
				slides.Next()

	slider.compose()
	slider

slides = Slider('.noivas-gallery .slider-item')
slidesContainer = $('.noivas-gallery')[0]
slides.RenderControls slidesContainer
slides.Play()
slidesContainer.addEventListener 'mouseover', () -> slides.Pause()
slidesContainer.addEventListener 'mouseout' , () -> slides.Play()
