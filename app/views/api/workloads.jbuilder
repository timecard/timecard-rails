json.array! @workloads do |workload|
  json.partial! "workload", workload: workload
end
