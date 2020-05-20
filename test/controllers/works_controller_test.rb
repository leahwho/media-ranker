require "test_helper"

describe WorksController do
  
  describe 'index' do
    it 'responds with success when there are many works saved' do
      works(:oryx)
      works(:blackstar)
      
      get works_path
      
      must_respond_with :success
    end
    
    it 'responds with success when there are no works saved' do
      get works_path
      
      must_respond_with :success
    end
  end
  
  describe 'home' do
    it 'responds with success when there are works saved in each category' do
      works(:oryx)
      works(:blackstar)
      works(:brazil)
      
      get root_path
      
      must_respond_with :success
    end
    
    it 'responds with success when there are works in only one category' do
      works(:oryx)
      
      get root_path
      
      must_respond_with :success
    end
    
    it 'responds with success when there are no works in any category' do
      get root_path
      
      must_respond_with :success
    end
  end
  
  describe 'show' do
    it 'responds with success when showing existing and valid work' do
      work = works(:overstory)
      
      get work_path(work.id)
      
      must_respond_with :success
    end
    
    it 'responds with 404 with an invalid work id' do
      id = 'banana'
      
      get work_path(id)
      
      must_respond_with :not_found
    end
  end
  
  describe 'new' do
    it 'responds with success' do
      get new_work_path
      
      must_respond_with :success
    end
  end
  
  describe 'create' do
    it 'can create a new work with valid info and redirect' do
      work_info = {
        work: {
          title: 'Waynes World',
          category: 'movie',
          creator: 'Penelope Spheeris',
          description: 'Wayne (Mike Myers) and Garth (Dana Carvey) battle to save their show and Waynes girlfriend from Lowe.',
          publication_year: 1992
        }
      }
      
      expect { post works_path, params: work_info }.must_differ "Work.count", 1
      
      new_work = Work.find_by(title: work_info[:work][:title])
      
      expect(new_work.category).must_equal work_info[:work][:category]
      expect(new_work.creator).must_equal work_info[:work][:creator]
      expect(new_work.description).must_equal work_info[:work][:description]
      expect(new_work.publication_year).must_equal work_info[:work][:publication_year]
      
      expect(flash[:success]).must_equal "#{new_work.title} was successfully saved."
      
      must_respond_with :redirect
      must_redirect_to work_path(new_work.id)
      
      
    end
    
    it 'does not create a new work if form data violates validations' do
      work_info = {
        work: {
          title: '',
          category: 'movie',
          creator: 'Terry Gilliam',
          description: 'Original, absorbing dark comedy about daydreaming civil servant',
          publication_year: 1985
        }
      }
      
      expect { post works_path, params: work_info }.wont_differ "Work.count"
      
      must_respond_with :bad_request
    end
  end
  
  describe 'edit' do
    it 'responds with success when retrieving existing, valid work' do
      old_work = works(:moonstruck)
      
      get edit_work_path(old_work)
      
      must_respond_with :success
    end
    
    it 'responds with redirect when retrieving non-existing work' do
      old_id = 'milk'
      
      get edit_work_path(old_id)
      
      must_respond_with :not_found
    end
  end
  
  describe 'update' do
    it 'updates existing work with valid info accurately, and redirects' do
      old_work = works(:rising)
      old_id = old_work.id
      
      updated_info = {
        work: {
          title: 'Titanic Rising B Sides',
          category: 'album',
          creator: 'Weyes Blood',
          description: 'Natalie Mering’s fourth album is a grand, sentimental ode to living and loving in the shadow of doom. It is her most ambitious and complex work yet.',
          publication_year: 2020
        }
      }
      
      expect {
        patch work_path(old_work), params: updated_info
      }.wont_differ 'Work.count'
      
      updated_work = Work.find_by(id: old_id)
      
      expect(updated_work.title).must_equal updated_info[:work][:title]
      expect(updated_work.category).must_equal updated_info[:work][:category]
      expect(updated_work.creator).must_equal updated_info[:work][:creator]
      expect(updated_work.description).must_equal updated_info[:work][:description]
      expect(updated_work.publication_year).must_equal updated_info[:work][:publication_year]
      
      expect(flash[:success]).must_equal "#{updated_work.title} was successfully saved!"
      
      must_respond_with :redirect
      must_redirect_to work_path(updated_work)
      
    end
    
    it 'does not update work if given an invalid id, responds with 404' do
      id = 'bananataco'
      
      updated_info = {
        work: {
          title: 'Titanic Rising B Sides',
          category: 'album',
          creator: 'Weyes Blood',
          description: 'Natalie Mering’s fourth album is a grand, sentimental ode to living and loving in the shadow of doom. It is her most ambitious and complex work yet.',
          publication_year: 2020
        }
      }
      
      expect {
        patch work_path(id: id), params: updated_info
      }.wont_differ "Work.count"
      
      must_respond_with :not_found
    end
    
    it 'does not update work if form data violates validations' do
      title = 'Titanic Rising'
      old_work = works(:rising)
      id = old_work.id
      
      updated_info = {
        work: {
          title: '',
          category: 'album',
          creator: 'Weyes Blood',
          description: 'Natalie Mering’s fourth album is a grand, sentimental ode to living and loving in the shadow of doom. It is her most ambitious and complex work yet.',
          publication_year: 2020
        }
      }
      
      expect {
        patch work_path(id: id), params: updated_info
      }.wont_differ 'Work.count'
      
      found_work = Work.find_by(id: id)
      expect(found_work.title).must_equal title
      
      must_respond_with :bad_request
    end
  end
  
  describe 'destroy' do
    it 'destroys the work in the database when work exists and redirects' do
      work_to_delete = works(:blackstar)
      
      expect {
        delete work_path(work_to_delete)
      }.must_differ 'Work.count', -1
      
      expect(flash[:success]).must_equal "#{work_to_delete.title} was successfully deleted."
      
      must_respond_with :redirect
      must_redirect_to root_path
    end

    it 'does not change the database when work does not exist, responds with not_found' do
      id = 'tamale'

      expect {
        delete work_path(id: id)
      }.wont_differ 'Work.count'

      must_respond_with :not_found
    end
  end
  
end
