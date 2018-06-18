require 'rbconfig'

# Utility to load native binaries on Java CLASSPATH
class NativeFolder
  attr_reader :os, :bit

  WIN_FORMAT = 'windows%d'.freeze
  LINUX_FORMAT = 'linux%d'.freeze
  WIN_PATTERNS = [
    /bccwin/i,
    /cygwin/i,
    /djgpp/i,
    /ming/i,
    /mswin/i,
    /wince/i
  ].freeze

  def initialize
    @os = RbConfig::CONFIG['host_os'].downcase
    @bit = java.lang.System.get_property('os.arch') =~ /64/ ? 64 : 32
  end

  def name
    return format(WIN_FORMAT, bit) if WIN_PATTERNS.any? { |pat| pat =~ os }
    return format(LINUX_FORMAT, bit) if os =~ /linux/
    'macosx'
  end

  def extension
    return '*.so' if os =~ /linux/
    return '*.dll' if WIN_PATTERNS.any? { |pat| pat =~ os }
    '*.dylib' # MacOS
  end
end

require 'rbconfig'

# Utility to load native binaries on Java CLASSPATH
# HACK until jruby returns a more specific 'host_os' than 'linux'
class NativeFolder
  attr_reader :os, :bit

  LINUX_FORMAT = 'linux%s'.freeze
  ARM32 = '-armv6hf'.freeze
  # ARM64 = '-aarch64'.freeze
  WIN_FORMAT = 'windows%d'.freeze
  WIN_PATTERNS = [
    /bccwin/i,
    /cygwin/i,
    /djgpp/i,
    /ming/i,
    /mswin/i,
    /wince/i
  ].freeze

  def initialize
    @os = RbConfig::CONFIG['host_os'].downcase
    @bit = java.lang.System.get_property('os.arch')
  end

  def name
    return format(WIN_FORMAT, bit) if WIN_PATTERNS.any? { |pat| pat =~ os }
    return format(LINUX_FORMAT, bit) if /linux/.match?(os)
    end
    raise 'Unsupported Architecture'
  end

  def extension
    return '*.so' if /linux/.match?(os)
    return '*.dll' if WIN_PATTERNS.any? { |pat| pat =~ os }
    raise 'Unsupported Architecture'
  end
end
