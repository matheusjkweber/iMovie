# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'iMovie' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iMovie
  pod 'SDWebImage', '~> 5.0'
  
  target 'iMovieTests' do
      inherit! :search_paths
      # Pods for testing
      pod 'Nimble', '~> 7.0.2'
      pod 'Nimble-Snapshots'
      pod 'Quick'
    end
  
    target 'iMovieUITests' do
      inherit! :search_paths
      pod 'Nimble', '~> 7.0.2'
      pod 'Quick'
      pod 'KIF', :configurations => ['Debug']
    
    end
  

end
