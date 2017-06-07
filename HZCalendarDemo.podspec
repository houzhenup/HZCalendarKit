Pod::Spec.new do |s|
s.name         = 'HZCalendarDemo'
s.version      = '1.0.0'
s.summary      = '一款简单优雅的日历控件'
s.description  = "一款简单优雅的日历控件，哈哈哈"
s.homepage     = 'https://github.com/houzhenup/HZCalendarKit'
s.license      = 'MIT'
s.authors      = { "侯震" => "450351763@qq.com" }
s.platform     = :ios, '6.0'
s.source       = {:git => 'https://github.com/houzhenup/HZCalendarKit.git', :tag => s.version}
s.source_files = 'HZCalendarKit/**/*.{h,m}'
s.resource     = 'HZCalendarKit/*.png'
s.requires_arc = true
end

