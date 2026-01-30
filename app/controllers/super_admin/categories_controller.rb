# frozen_string_literal: true

class SuperAdmin::CategoriesController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Category.where(deleted_at: nil).ransack(params[:q])
    @categories = @q.result.order(created_at: :desc)
    @pagy, @categories = pagy(@categories, limit:)
  end

  def new
    @category = Category.new
  end

  def create
    result = Categories::Create.call(
      category_params: category_params
    )

    if result.success?
      redirect_to new_super_admin_category_path, notice: result.payload[:message]
    else
      @category = result.error[:category]

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = category_scope
  end

  def update
    result = Categories::Update.call(
      category: category_scope,
      category_params: category_params
    )

    if result.success?
      category = result.payload[:category]

      redirect_to edit_super_admin_category_path(category), notice: result.payload[:message]
    else
      @category = result.error[:category]

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    result = Categories::SoftDelete.call(
      category: category_scope
    )

    if result.success?
      redirect_to super_admin_categories_path, notice: result.payload[:message]
    else
      redirect_to super_admin_categories_path, alert: result.error[:category]
    end
  end

  def activate
    result = Categories::Activate.call(
      category: category_scope
    )

    if result.success?
      redirect_to super_admin_categories_path, notice: result.payload[:message]
    else
      redirect_to super_admin_categories_path, alert: result.error[:category]
    end
  end

  def deactivate
    result = Categories::Deactivate.call(
      category: category_scope
    )

    if result.success?
      redirect_to super_admin_categories_path, notice: result.payload[:message]
    else
      redirect_to super_admin_categories_path, alert: result.error[:category]
    end
  end

  def search
    q = params[:q].to_s.strip[0, 100]

    categories = Category
      .where(is_active: true, deleted_at: nil)
      .where("name ILIKE ?", "%#{q}%")
      .order(:name)
      .limit(15)

    render json: categories.map { |d|
      { value: d.id, label: d.name }
    }
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def category_scope
    Category.find(params[:id])
  end
end
