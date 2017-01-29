# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def myPods
    pod 'SwiftDate','~>4.0'   # methods to manage dates
    pod 'SwiftyDropbox'       # dropbox pod
    pod 'Gloss'               # JSON pod
    pod 'ExpandableDatePicker' # date/Time/TimeZone picker
    pod 'SwiftyPickerPopover'
end

target 'SwiftEvents' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SwiftEvents
  myPods

  target 'SwiftEventsTests' do
    inherit! :search_paths
  end

  target 'SwiftEventsUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
