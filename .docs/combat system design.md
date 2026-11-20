# Combat System Design 101

## Contents
- Data-Oriented Design(DOD)
- Entity Component System(ECS)
- Composition over Inheritance
- Event-Driven
- Finite State Machines(FSM)
- Behavior Trees
- Command Pattern
- Action Queue
- Status Effect Pipeline
- Rule-Based Systems
- Strategy Pattern
- Message Passing
- Dependency Inversion
- Tick-Based Actions
- Layered Combat Processing


## Data-Oriented Design
This is very much the philosophu behind ECS.
Instead of thinking:
> "A sword object attacks an Enemy object."
You think:
> "Attack data is processed over all entities that can attack."
Instead of sorting behavior inside objects, you store data and have systems operate on it.

Traditional OOP:
```
Player
 ├── Attack()
 ├── Move()
 ├── Heal()

Enemy
 ├── Attack()
 ├── Move()
 └── Die()
```
Data-Oriented:

```
Entities
    ↓

Components
- Health
- Position
- AttackStats
- Mana
- Team

Systems
- MovementSystem
- DamageSystem
- HealingSystem
- AISystem
```

This pattern breaks away from the traditional "in-sequence" pattern, and instead provides *modules* which operates **for** the Enteties.
Benefits:
- Easier to optimize.
- Modular.
- Easier multiplayer synchronization.
- Fewer inheritance headaches.

Data-oriented Design(DOD) can feel strange at first, because it asks you to stop thinking about **Objects that do things**, but instead thinks about **data that gets processed**.

### The object-Oriented way of thinking
Every Object calls another object upon interaction. When a Player hits an Enemy, the sequence of procedures happens accordingly:
```
Player
 └── Weapon
      └── Attack(Enemy)
    ↓
Enemy.TakeDamage()
    ↓
Armor.CalculateReduction()
    ↓
Health.Remove()
    ↓
Animation.PlayHit()
    ↓
Particles.Spawn()
    ↓
Death.Check()
```
As your combat starts to grow, a sword might become:
```
Sword
 ├─ Critical Hits
 ├─ Lifesteal
 ├─ Fire Damage
 ├─ Poison
 ├─ Knockback
 ├─ Combo Logic
 ├─ Buffs
 ├─ Debuffs
 ├─ Achievements
 └─ Network Sync
```
Now your sword class "knows" way too much.

### The Data-Oriented mindset
Instead, ask:
> What piece of data exist?
Not:
> What Object exist?

Combat might just be data.
```
Entity 17

Position
Health
Armor
FireResistance
Velocity
Team
PoisonStacks
WeaponStats
```
Nothing here attacks, dies or plays animations. They are *just* numbers.

### Systems do the work
Instead of the player attacking, you expose systems to **objects in combat**. 
```
CombatSystem

Find attacker
Find defender
Compute damage
Create damage event
```
```
DeathSystem

for every entity
if Health <= 0
Mark Dead
```

```
AnimationSystem

For every damage event
Play hit animation
```

### Example combat flow
Imagine a fireball. Instead of :
```cpp
Fireball::Explode()
{
    enemy->TakeDamage(30);
    enemy->Burn();
    enemy->Knockback();
    enemy->PlayAnimation();
}
```
Think of it as generating data.
```
Step 1: CollisionSystem
	Fireball collided -> hit event

Step 2: CombatSystem
	Hit event -> get_damage = 30 -> damage event

Step 3: DamageSystem
	Damage event -> (health -= 30)

Step 4: StatusEffectSystem
	Damage event -> fire damage? -> apply burning

Step 5: AnimationSystem
	Damage event -> play hit animation

Step 6: FloatingTextSystem
	Damage event -> show "30"
```
Nobody directly called anyone else.
Everyone simply reacted to data.

### Components become "facts"
Components aren't behavior. They're facts.
Instead of:
```
Enemy
```
You have
```
Health = 120
Armor = 20
Burning = true
Velocity = (1,0)
PoisonStacks = 4
```
The Entity is just a collection of facts.

### Why this scales so well
When adding **more** ways to deal damage, instead of directly rewriting hierarchy and inheritance, you directly add another *module* to an already existing system.

Suppose tomorrow you add `Thorns`.
OOP:
```
You might edit

Sword
Enemy
Damage
Armor
Animation
```
Because damage originates from many places.

Data-Oriented:
Create `ThornsSystem`
It watches for `Damage Events`
When someone receives damage, Deal reflected damage. Done.
No combat code changed.

### Buffs Becomes easy
Imagine `+20% damage while burning`
You don't modify every attack.

Instead, CombatSystem asks
```
Damage = BaseDamage
↓
ModifierSystem
↓
Is attacker burning?
↓
No
↓
Damage Unchanged
```

Or
```
Damage = BaseDamage
↓
ModifierSystem
↓
Attacker enraged
↓
Damage x1.5
↓
Target frozen
↓
Damage x1.2
```

### Think in passes
One of the biggest DOD ideas is processing everythign in **passes**.
Instead of
```
Player attacks
↓
Enemy reacts
↓
Enemy dies
↓
Loot drops
↓
Quest updates
```
Think
```
Combat pass:	Generate damage
Buffs pass:		Generate modifier from effetcs
Damage pass:	Subtract health
Death pass:		Mark dead entities
Loot pass:		Spawn loot
Cleanup pass:	Remove dead entities
```
Every system only cares about one job.

### Cache Friendliness(the "computer" reason)
There's also performance benefits.
Within the BYOND world, datums(objects) work in conjunction with inheritance.
Just like paths, `/mob/player` inherits all attributes form `/mob`.
On a deeper level, every object existing within the world(at runtime) receives a template dataset from one prototype.
If 10,000 objects of type `/mob/monster` exists, the only data being multiplied are the datapoints being different from the prototype object.

When handling Data-oriented systems, only one instance of any combat system exists.
They act independant from other objects, and only cares about information. They instead *control* affected Objects when needed to.

An example to this would be:
```cpp
// Pseudo code
effect
	#define MULTIPLY_DAMAGE 1
	#define MULTIPLY_MITIGATION 2
	#define ON_HIT 4
	var
		effect_flags // bitwise
		multiplier = 0 //normalised
		on_hit_chance = 0 // 0 to 100
	
	proc
		OnHit()
			if(effect_flags & ON_HIT)
				return prob(on_hit_chance) ? multiplier : 0
		
#define DAMAGE_EVENT(attacker, receiver, base_damage, damage_type) CombatSystem.damage(attacker, receiver, base_damage, damage_type)

CombatSystem
	const
		Fire = "Fire"
		Frost = "Frost"
		Physical = "Physical"
		Bleed = "Bleed"
		Poison = "Poison"

	proc
		damage(mob/attacker, mob/receiver, base_damage, DamageType/damage_type, spell_name="")
			// Phase 1: Get damage
			var/damage = base_damage

			// Phase 2: Apply offensive buffs from attacker
			apply_offensive_multipliers(attacker.buffs, &damage)
			
			// Phase 3: Apply defensive buffs from receiver
			apply_mitigation_multipliers(receiver.buffs, &damage)

			// Phase 4: Apply any on-hit effects
			apply_on_hit_effects(attacker.buffs, &damage)

			// Phase 5: Apply defensive values from receiver
			apply_defensives(receiver.defense, &damage)
			

			// Phase 6: filter damage
			damage = max(0,round(damage))

			// Phase 7: Deal damage
			deal_damage(&receiver.health, &damage)

			// Phase 8: is dead?
			if(is_dead(receiver))
				// marked as dead
				receiver.died()
			
			// Phase 9: Message
			output_damage_to(attacker, receiver, damage, spell_name)

		apply_offensive_multipliers(list/buffs, damage)
			var/multiplier = 1
			for(var/effect/i in buffs)
				if(i.effect_flags & MULTIPLY_DAMAGE)
			*damage *= multiplier

		apply_mitigation_multipliers(list/buffs, damage)
			var/multiplier = 1
			for(var/effect/i in buffs)
				if(i.effect_flags & MULTIPLY_MITIGATION)
					multiplier += i.multiplier
			*damage *= multiplier
		
		apply_on_hit_effects(list/buffs, damage)
			var/multiplier = 1
			for(var/effect/i in buffs)
				multiplier += i.OnHit()
			*damage *= multiplier

		apply_defensives(defense=0, damage)
			*damage -= *defense

		deal_damage(health, damage)
			*health -= damage

		is_dead(mob/receiver)
			return (receiver.health <= 0)

		output_damage_to(mob/attacker, mob/receiver, damage, spell_name)
			var/attacker_text = "[spell_name] hit [receiver.name] for [damage]!"
			var/receiver_text = "[attacker.name] hit you with [spell_name] for [damage]!"

			if(is_dead(receiver))
				damage -= receiver.health
				receiver_text += " ([damage] overkill!)<br>[attacker.name] killed you!"
				attacker_text += " ([damage] overkill!)<br>You killed [receiver.name]!"

			attacker << attacker_text
			receiver << receiver_text
```