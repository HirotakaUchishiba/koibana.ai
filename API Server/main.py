from fastapi import FastAPI, HTTPException
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, Table
from sqlalchemy.orm import sessionmaker, relationship, session
from sqlalchemy.orm import declarative_base
from passlib.context import CryptContext
from typing import Optional, List
from pydantic import BaseModel
import openai


openai.api_key = "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"

app = FastAPI()

Base = declarative_base()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

DATABASE_URL = "postgresql://postgres:pgsqlpw@localhost:5432/user_data"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)

class Question(BaseModel):
    question: str

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    email = Column(String, unique=True, index=True, nullable=True)
    full_name = Column(String, nullable=True)
    hashed_password = Column(String)
    hobbies = relationship("Hobby", back_populates="user")

class Hobby(Base):
    __tablename__ = "hobbies"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
    description = Column(String, nullable=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    user = relationship("User", back_populates="hobbies")

class UserCreate(BaseModel):
    username: str
    email: Optional[str] = None
    full_name: Optional[str] = None
    password: str

class HobbyCreate(BaseModel):
    name: str
    description: Optional[str] = None

Base.metadata.create_all(bind=engine)

@app.post("/usercreate/")
def create_user(user: UserCreate):
    db = SessionLocal()
    try:
        hashed_password = pwd_context.hash(user.password)
        db_user = User(username=user.username, email=user.email, full_name=user.full_name, hashed_password=hashed_password)
        print(db_user)
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return db_user
    except:
        db.rollback()
        raise HTTPException(status_code=400, detail="Username already registered")
    finally:
        db.close()

@app.post("/users/{user_id}/hobbies/")
def create_hobby_for_user(user_id: int, hobby: HobbyCreate):
    db = SessionLocal()
    try:
        db_user = db.query(User).filter(User.id == user_id).first()
        if db_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        db_hobby = Hobby(name=hobby.name, description=hobby.description, user_id=user_id)
        db.add(db_hobby)
        db.commit()
        db.refresh(db_hobby)
        return db_hobby
    except:
        db.rollback()
        raise HTTPException(status_code=400, detail="Error creating hobby")
    finally:
        db.close()

@app.get("/users/{user_id}/hobbies/", response_model=List[HobbyCreate])
def read_hobbies_for_user(user_id: int):
    db = SessionLocal()
    try:
        db_user = db.query(User).filter(User.id == user_id).first()
        if db_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return db_user.hobbies
    except:
        raise HTTPException(status_code=400, detail="Error reading hobbies")
    finally:
        db.close()

@app.get("/users_by_hobby/{hobby_name}")
async def get_users_by_hobby(hobby_name: str):
    db = SessionLocal()
    users = get_users_with_same_hobby(db, hobby_name)
    return users

def get_users_with_same_hobby(db: session, hobby_name: str):
    # 查询拥有指定兴趣的所有Hobby记录
    hobbies = db.query(Hobby).filter_by(name=hobby_name).all()

    # 提取Hobby记录中的用户ID
    user_ids = [hobby.user_id for hobby in hobbies]

    # 查询所有拥有该兴趣的用户
    users = db.query(User).filter(User.id.in_(user_ids)).all()

    return users
