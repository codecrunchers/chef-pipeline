#pipeline stuff
default['pipeline']['services'] = [ 'http://localhost:18080','http://localhost:19000','http://localhost:10080']
default['pipeline']['docker_file'] =  '/home/alan/devel/docker/docker-pipeline/docker-ci-tool-stack/docker-compose.yml'
default['pipeline']['gitlab_url'] =  'http://localhost:10080/api/v3'
default['pipeline']['user'] =  [{:name=>"Alan",:sshkey=>"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJOvFnDlHcaExaM8DnVHO1V72F0S6JY9cr/COgGNqIyC+BzUxPaXGO8RpdzXG+xk8angygAr13Z0N3uup0bWNeHgWhaRhrkm2Mk8F3Bq8i+IVJqckyS3waxCfMcZYV5nQ5dAyeU18hbbQ36MIuS9JzqrFyBi2Zn1/pJVrTB3vNCE6rkQBqENQN+MMRfn9s8EGO4o6WrHtt8H0A3HxCJ1hDjLAKlUqA51uFDTSi5qa7EFvjBWPcn2gA09fDbbVztUxLfPAWllOL6ZjpGwa0lLdYR+Fbxbv6wxypz33xEs3Wpj+08bkep3QX2wJbcw7xvsrMmJ6UFn3Tmv1szYx41bbtNdLflRFbjVVCuwjcl/2ic+e7Tp7KxbGDfo7L5n4e/NLt0WBH8v1JUAh25Beu/Hua7Ozh1G2GK/1+HOj5tqF5yrarhEJ++A5+Si5tUieQqbGlvJ4l0HGj1ueJ6pLUZqMEEAIdHiF/oyyA+cLmoaR083CcTeZT2jHN6dw22mlCufLXcLoHij5vmSSy1NVezEfFonWqUA5UOWellnKMGyn9vYkR8Tma2tEd27p/SwILf19BIkVj7yDsJHDMJOq01vpNdPG3diHg7a4iF4aA5nzr2XaQhmm2s26VZLCaUzQVCwvZkkPK438wnqUrFEg2h8TM1PCeOjyfTMn0Y/e5wArPQQ== cd-demo@email.com"}]
default['pipeline']['project_name']='OVERRIDEME'
#Archetype generation
default['pipeline']['archetype']['groupId']='pl.codeleak'
default['pipeline']['archetype']['archetypeId']='spring-mvc-quickstart'
default['pipeline']['archetype']['archetypeVersion']='1.0.0'
default['pipeline']['archetype']['archetypeRepo']='http://kolorobot.github.io/spring-mvc-quickstart-archetype'
default['pipeline']['maven_path']='/home/alan/apps/apache-maven-3.1.0/bin/mvn'
default['pipeline']['java_home']='/home/alan/apps/jdk1.8.0/'




