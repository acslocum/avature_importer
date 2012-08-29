
class AvatureResume
  attr_accessor :contact_id
  
  def initialize(headers, candidate, p)
    @hash = Hash[headers.zip(candidate)]
    @p = p
  end
  
  def person_info
    {
      :firstName => @hash["Name"].split(',')[1].strip,
      :lastName => @hash["Name"].split(',')[0].strip,
      :jobTitle => nil,
      :company => @hash["Company or School"],
      :sourceId => 97,
      :salutationId => nil
    }
  end
  
  def name
     @hash["Name"]
  end
  
  def contact_info
    contact = @hash["Contact Info"].split(' ')
    {
      :emails => [{:emailAddress => contact[3], :emailTypeId=>2}],
      :phoneNumbers => [{:phoneNumber => contact[2], :phoneTypeId => 1}]
    }
  end
    
  def notes
    [
      @hash["Mailing Address"],
      "Work Location: #{@hash['Work Location Preference']}\nAvailability: #{@hash['Availability']}",
      "GPA: #{@hash['GPA']}\nMajor#{@hash['Major']}\nEducation Status: #{@hash['Education Status']}\nCurrent Job Status: #{@hash['Current Job Status']}",
      "#{@hash['Resume URL']}\n<href='#{@hash['Resume URL']}'>Link</a>",
      "U.S. Citizen: #{@hash['U.S. Citizen']}\nCan Legally Work in U.S.: #{@hash['Can Legally Work in U.S.']}",
      "Contact Preference: #{@hash['Contact Info'].split(' ')[1]}",
      interests.join("\n")
    ]
  end
  
  def interests
    all_interests = []
    @hash.each { |key, value| 
      all_interests << key if value == "Yes"
    }
    all_interests.sort
  end
  
  def personal_tags
    ["acslocum","oadubrak", @hash["Job Interest"], "hopper12"]
  end
  
  def m_person
    [ 
      [
        "Sperson_Person.save",
        [
          {
            :personalTags => personal_tags,
            :personInfo => person_info,
            :contactInfo => contact_info,
            :access => {:type => 1},
            :isPosibleDuplicated => nil
          }
        ]
      ],
      ["Slist_ListFormField.1",[-719]],
      ["Slist_ListFormField.1",[-720]],
      ["Suser_User.1",[-721]],
      ["Slist_ListFormField.1",[-722]],
      ["Slist_ListFormField.1",[-723]],
      ["Sworkflow_Workflow.1",[-724]],
      ["Slist_ListFormField.1",[-725]],
      ["Sworkflow_Workflow.1",[-726]],
      ["Slist_ListFormField.1",[-727]],
      ["Suser_User.1",[-728]],
      ["Scountry_Country.1",[-729]],
      ["Slist_ListFormField.1",[-730]],
      ["Slist_ListFormField.1",[-731]],
      ["Slist_ListFormField.1",[-732]],
      ["Sworkflow_Workflow.1",[-733]],
      ["Sperson_PipelineListSpec.1",[-718]]
    ]
  end
  
  def m_note(note)
    [
      [
        "Sjournal_Note.save",
        [
          {
            :text => note,
            :entryContainer => {:contactId => @contact_id, :contactTypeId => 2, :entryData => nil}
          }
        ]
      ]
    ]
  end
  
  def c
    "iatsSharedSESSID"
  end
    
  def person_content
    { :m => m_person, :p => @p, :c => c }
  end
  
  def note_content(note)
    { :m => m_note(note), :p => @p, :c => c }
  end
  
  
end