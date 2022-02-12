# config.ru
require 'rack/protection'
use Rack::Protection
run App