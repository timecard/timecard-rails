json.array! @workers do |worker|
  json.partial! "worker", worker: worker
end
