def find_spammers
  spammers = Set.new
  User.all.each do |u|
    puts "Checking user #{u.email}"
    hp_last = ProjectHoneypot.lookup(u.last_sign_in_ip.to_s)
    if hp_last.suspicious?
      puts "  Last IP suspicious: #{hp_last.ip_address}"
      spammers << u
    end
  
    if u.last_sign_in_ip != u.current_sign_in_ip
      hp_current = ProjectHoneypot.lookup(u.current_sign_in_ip.to_s)
      if hp_current.suspicious?
        puts "  Current IP suspicious: #{hp_last.ip_address}"
        spammers << u
      end
    end
  end
  puts "Found #{spammers.size} spammers"
  spammers
end

find_spammers
