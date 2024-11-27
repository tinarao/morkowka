extends CanvasModulate

@export var elapsed_minutes: int
@export var gradient: GradientTexture1D
@export var ingame_speed = 1.0
@export var initial_hour = 12:
	set(h):
		initial_hour = h
		time = INGAME_TO_REAL_MINUTE_DURATION * initial_hour * MINUTES_PER_HOUR

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

var time: float = 0.0
var past_minute: float = -1.0
var past_day: float = -1.0

signal time_tick(day: int, hour: int, minute: int)
signal day_tick(day: int, elapsed_minutes: int)

func _ready() -> void:
	time = INGAME_TO_REAL_MINUTE_DURATION * initial_hour * MINUTES_PER_HOUR

func _process(delta: float) -> void:
	time += delta / 10
	var value = (sin(time - PI / 2) + 1.0) / 2.0
	self.color = gradient.gradient.sample(value)

	recalculate_time()

func recalculate_time() -> void:
	var minutes_elapsed = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	elapsed_minutes = minutes_elapsed
	var current_day_minutes = minutes_elapsed % MINUTES_PER_DAY

	var day = int(minutes_elapsed / MINUTES_PER_DAY)
	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute = int(current_day_minutes % MINUTES_PER_HOUR)

	if past_day != day:
		past_day = day
		print(day == past_day)
		day_tick.emit(day, elapsed_minutes)

	if past_minute != minute:
		past_minute = minute
		time_tick.emit(day, hour, minute)
