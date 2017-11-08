require "/scripts/vec2.lua"

function init()
  self.searchDistance = config.getParameter("searchRadius")
  
  if config.getParameter("searchStartDelay") ~= nil then
	self.searchEnabled = false
	self.countdownTimer = config.getParameter("searchStartDelay")
  else
	self.searchEnabled = true
  end
end

function update(dt)
  if self.searchEnabled == true then
	local targets = world.entityQuery(mcontroller.position(), self.searchDistance, {
      withoutEntityId = projectile.sourceEntity(),
      includedTypes = {"creature"},
      order = "nearest"
    })

	for _, target in ipairs(targets) do
	  if entity.entityInSight(target) and world.entityCanDamage(projectile.sourceEntity(), target) then
		projectile.die()
		return
	  end
	end
  else
	self.countdownTimer = math.max(0, self.countdownTimer - dt)
	if self.countdownTimer == 0 then
	  self.searchEnabled = true
	end
  end
end
