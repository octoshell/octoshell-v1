module UserAbilities
  def may?
    ability.may?
  end
  
  def maynot?
    ability.maynot?
  end
  
  def abilities
    sort = %{
      (case when available then 1 when available is null then 2 else 3 end) asc
    }
    abilities = Ability.where(group_id: group_ids).order(sort).uniq_by(&:to_definition)
    abilities.any? ? abilities : Ability.default
  end
  
  def ability
    @ability ||= begin
      mm = MayMay::Ability.new(self)
      abilities.each do |ability|
        method = ability.available ? :may : :maynot
        mm.send method, ability.action_name, ability.subject_name
      end
      mm
    end
  end
end
