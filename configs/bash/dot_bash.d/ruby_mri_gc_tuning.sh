# http://www.rubyenterpriseedition.com/documentation.html
# 37signals uses the following settings in production
RUBY_HEAP_MIN_SLOTS=600000    # This is 60(!) times larger than default
RUBY_GC_MALLOC_LIMIT=59000000 # This is 7 times larger than default
RUBY_HEAP_FREE_MIN=100000     # This is 24 times larger than default
